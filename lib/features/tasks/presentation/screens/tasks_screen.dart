import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../app/providers.dart';
import '../../../../core/notifications/local_notification_scheduler.dart';
import '../../../../core/notifications/notification_channels.dart';
import '../../../../core/notifications/notification_scheduler.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/tables.dart';

// ── Notifications ─────────────────────────────────────────────────────────────

int _taskNotifId(int taskId) => 8000 + taskId;

Future<void> _scheduleTaskNotif(Task task) async {
  if (task.dueDate == null || task.dueTime == null || task.isCompleted) return;
  final parts = task.dueTime!.split(':');
  if (parts.length < 2) return;
  final date = DateTime.tryParse(task.dueDate!);
  if (date == null) return;
  final at = DateTime(date.year, date.month, date.day,
      int.tryParse(parts[0]) ?? 0, int.tryParse(parts[1]) ?? 0);
  if (at.isBefore(DateTime.now())) return;

  final plugin = FlutterLocalNotificationsPlugin();
  await LocalNotificationScheduler.initialize(plugin);
  final scheduler = LocalNotificationScheduler(plugin);
  await scheduler.scheduleAll([
    ScheduledAlarm(
      id: _taskNotifId(task.id),
      title: task.priority == 'high' ? '🔴 ${task.title}' : task.title,
      body: 'Task due now',
      at: at,
      timezoneId: tz.local.name,
      channelId: NotificationChannels.khataAlert,
      payload: '{"type":"task","id":${task.id}}',
    ),
  ]);
}

Future<void> _cancelTaskNotif(int taskId) async {
  final plugin = FlutterLocalNotificationsPlugin();
  await LocalNotificationScheduler.initialize(plugin);
  await plugin.cancel(id: _taskNotifId(taskId));
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _todayStr() {
  final now = DateTime.now();
  return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

String _tomorrowStr() {
  final tm = DateTime.now().add(const Duration(days: 1));
  return '${tm.year.toString().padLeft(4, '0')}-${tm.month.toString().padLeft(2, '0')}-${tm.day.toString().padLeft(2, '0')}';
}

Color _hexColor(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  } catch (_) {
    return const Color(0xFF6750A4);
  }
}

// ── Presets ───────────────────────────────────────────────────────────────────

const _kPresetColors = [
  '#6750A4', '#1976D2', '#388E3C', '#D32F2F',
  '#F57C00', '#7B1FA2', '#00796B', '#5D4037',
];

const _kPresetEmojis = [
  '📋', '🏠', '💼', '🛒', '🎯', '📚', '🏋️', '✈️', '💰', '🎮', '👨‍👩‍👧', '⚡',
];

// ── Global selected-list state ────────────────────────────────────────────────

class _SelectedListIdNotifier extends Notifier<int?> {
  @override
  int? build() => null;
}

final _selectedListIdProvider =
    NotifierProvider<_SelectedListIdNotifier, int?>(_SelectedListIdNotifier.new);

// ── Providers ─────────────────────────────────────────────────────────────────

final _taskListsProvider = StreamProvider<List<TaskList>>((ref) =>
    ref.watch(appDatabaseProvider).taskListsDao.watchLists());

final _taskListMapProvider = StreamProvider<Map<int, TaskList>>((ref) =>
    ref.watch(appDatabaseProvider).taskListsDao.watchLists().map(
        (lists) => {for (final l in lists) l.id: l}));

final _overdueTasksProvider = StreamProvider<List<Task>>((ref) {
  final listId = ref.watch(_selectedListIdProvider);
  return ref.watch(appDatabaseProvider).tasksDao.watchOverdue(_todayStr(), listId);
});

final _todayTasksProvider = StreamProvider<List<Task>>((ref) {
  final listId = ref.watch(_selectedListIdProvider);
  return ref.watch(appDatabaseProvider).tasksDao.watchToday(_todayStr(), listId);
});

final _tomorrowTasksProvider = StreamProvider<List<Task>>((ref) {
  final listId = ref.watch(_selectedListIdProvider);
  return ref.watch(appDatabaseProvider).tasksDao.watchTomorrow(_tomorrowStr(), listId);
});

final _upcomingTasksProvider = StreamProvider<List<Task>>((ref) {
  final listId = ref.watch(_selectedListIdProvider);
  return ref.watch(appDatabaseProvider).tasksDao.watchUpcoming(_todayStr(), listId);
});

final _completedTasksProvider = StreamProvider<List<Task>>((ref) {
  final listId = ref.watch(_selectedListIdProvider);
  return ref.watch(appDatabaseProvider).tasksDao.watchCompleted(listId);
});

// ── Screen ────────────────────────────────────────────────────────────────────

enum _TaskTab { today, upcoming, completed }

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  _TaskTab _tab = _TaskTab.today;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lists = ref.watch(_taskListsProvider).value ?? [];
    final selectedListId = ref.watch(_selectedListIdProvider);

    final listChips = SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selectedListId == null,
            onSelected: (_) =>
                ref.read(_selectedListIdProvider.notifier).state = null,
          ),
          ...lists.map((list) {
            final color = _hexColor(list.color);
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onLongPress: () => _showListOptions(context, list),
                child: FilterChip(
                  avatar: Text(list.emoji,
                      style: const TextStyle(fontSize: 14)),
                  label: Text(list.name),
                  selected: selectedListId == list.id,
                  selectedColor: color.withValues(alpha: 0.2),
                  checkmarkColor: color,
                  onSelected: (_) =>
                      ref.read(_selectedListIdProvider.notifier).state =
                          list.id,
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('New List'),
              onPressed: () => _showListDialog(context),
            ),
          ),
        ],
      ),
    );

    final segmented = Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
      child: SegmentedButton<_TaskTab>(
        segments: const [
          ButtonSegment(
              value: _TaskTab.today,
              label: Text('Aaj'),
              icon: Icon(Icons.today_outlined)),
          ButtonSegment(
              value: _TaskTab.upcoming,
              label: Text('Baad Mein'),
              icon: Icon(Icons.calendar_month_outlined)),
          ButtonSegment(
              value: _TaskTab.completed,
              label: Text('Khatam'),
              icon: Icon(Icons.check_circle_outline)),
        ],
        selected: {_tab},
        onSelectionChanged: (s) => setState(() => _tab = s.first),
      ),
    );

    Widget body;
    switch (_tab) {
      case _TaskTab.today:
        body = _AajTab(onEdit: _showAddEditDialog);
      case _TaskTab.upcoming:
        body = _TaskList(
            provider: _upcomingTasksProvider,
            emptyMessage: 'Koi upcoming task nahi');
      case _TaskTab.completed:
        body = _TaskList(
            provider: _completedTasksProvider,
            emptyMessage: 'Abhi tak kuch complete nahi hua',
            showReopen: true);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: false,
        backgroundColor: scheme.surface,
      ),
      body: Column(children: [listChips, segmented, Expanded(child: body)]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Future<void> _showAddEditDialog(BuildContext context, WidgetRef ref,
      {Task? existing}) async {
    final result = await showDialog<TasksCompanion>(
      context: context,
      builder: (_) => _TaskDialog(existing: existing),
    );
    if (result == null) return;
    final dao = ref.read(appDatabaseProvider).tasksDao;
    int taskId;
    if (existing == null) {
      taskId = await dao.addTask(result);
    } else {
      await dao.updateTask(result);
      taskId = existing.id;
      await _cancelTaskNotif(taskId);
    }
    final saved = await dao.getTask(taskId);
    if (saved != null) await _scheduleTaskNotif(saved);
  }

  Future<void> _showListDialog(BuildContext context, {TaskList? existing}) async {
    final result = await showDialog<TaskListsCompanion>(
      context: context,
      builder: (_) => _ListDialog(existing: existing),
    );
    if (result == null) return;
    final dao = ref.read(appDatabaseProvider).taskListsDao;
    if (existing == null) {
      await dao.addList(result);
    } else {
      await dao.updateList(result);
    }
  }

  Future<void> _showListOptions(BuildContext context, TaskList list) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Text(list.emoji,
                  style: const TextStyle(fontSize: 22)),
              title: Text(list.name,
                  style: Theme.of(ctx).textTheme.titleMedium),
              subtitle: Text(
                'Long-press to edit or delete',
                style: Theme.of(ctx)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit List'),
              onTap: () => Navigator.pop(ctx, 'edit'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline,
                  color: Theme.of(ctx).colorScheme.error),
              title: Text('Delete List',
                  style: TextStyle(
                      color: Theme.of(ctx).colorScheme.error)),
              onTap: () => Navigator.pop(ctx, 'delete'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (!context.mounted) return;
    if (action == 'edit') {
      await _showListDialog(context, existing: list);
    } else if (action == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Delete "${list.name}"?'),
          content: const Text(
              'Tasks in this list will be unassigned, not deleted.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete')),
          ],
        ),
      );
      if (confirm == true) {
        final db = ref.read(appDatabaseProvider);
        await db.tasksDao.unassignList(list.id);
        await db.taskListsDao.deleteList(list.id);
        if (ref.read(_selectedListIdProvider) == list.id) {
          ref.read(_selectedListIdProvider.notifier).state = null;
        }
      }
    }
  }
}

// ── Aaj tab (Overdue + Today + Tomorrow) ─────────────────────────────────────

class _AajTab extends ConsumerStatefulWidget {
  const _AajTab({required this.onEdit});
  final Future<void> Function(BuildContext, WidgetRef, {Task? existing}) onEdit;

  @override
  ConsumerState<_AajTab> createState() => _AajTabState();
}

class _AajTabState extends ConsumerState<_AajTab> {
  bool _tomorrowExpanded = true;

  @override
  Widget build(BuildContext context) {
    final overdue = ref.watch(_overdueTasksProvider).value ?? [];
    final today = ref.watch(_todayTasksProvider).value ?? [];
    final tomorrow = ref.watch(_tomorrowTasksProvider).value ?? [];
    final scheme = Theme.of(context).colorScheme;

    final allEmpty = overdue.isEmpty && today.isEmpty && tomorrow.isEmpty;
    if (allEmpty) {
      return Center(
        child: Text(
          'Aaj koi kaam nahi — MashaAllah! 🎉',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: scheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
      children: [
        // Overdue
        if (overdue.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.warning_amber_rounded,
            label: 'Overdue (${overdue.length})',
            color: scheme.error,
          ),
          ...overdue.map((t) => _buildTile(t, isOverdue: true)),
          const Divider(height: 24),
        ],

        // Today
        if (today.isNotEmpty) ...[
          const _SectionHeader(icon: Icons.today_outlined, label: 'Aaj'),
          ...today.map((t) => _buildTile(t)),
        ] else if (overdue.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              'Aaj ke liye koi task nahi',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],

        // Tomorrow
        if (tomorrow.isNotEmpty) ...[
          const Divider(height: 24),
          InkWell(
            onTap: () =>
                setState(() => _tomorrowExpanded = !_tomorrowExpanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.upcoming_outlined,
                      size: 16, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    'Kal (${tomorrow.length})',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const Spacer(),
                  Icon(
                    _tomorrowExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: scheme.onSurfaceVariant,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_tomorrowExpanded)
            ...tomorrow.map(
              (t) => Opacity(opacity: 0.65, child: _buildTile(t)),
            ),
        ],
      ],
    );
  }

  Widget _buildTile(Task task, {bool isOverdue = false}) {
    return _TaskTile(
      task: task,
      showReopen: false,
      isOverdue: isOverdue,
      onEdit: () => widget.onEdit(context, ref, existing: task),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label, this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = color ?? scheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: c),
          const SizedBox(width: 8),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: c)),
        ],
      ),
    );
  }
}

// ── Task list (Baad Mein & Khatam tabs) ──────────────────────────────────────

class _TaskList extends ConsumerWidget {
  const _TaskList({
    required this.provider,
    required this.emptyMessage,
    this.showReopen = false,
  });

  final StreamProvider<List<Task>> provider;
  final String emptyMessage;
  final bool showReopen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (tasks) {
        if (tasks.isEmpty) {
          return Center(
            child: Text(emptyMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
          itemBuilder: (ctx, i) => _TaskTile(
            task: tasks[i],
            showReopen: showReopen,
            onEdit: () async {
              final result = await showDialog<TasksCompanion>(
                context: ctx,
                builder: (_) => _TaskDialog(existing: tasks[i]),
              );
              if (result == null) return;
              final dao = ref.read(appDatabaseProvider).tasksDao;
              await dao.updateTask(result);
              await _cancelTaskNotif(tasks[i].id);
              final saved = await dao.getTask(tasks[i].id);
              if (saved != null) await _scheduleTaskNotif(saved);
            },
          ),
        );
      },
    );
  }
}

// ── Task tile ─────────────────────────────────────────────────────────────────

class _TaskTile extends ConsumerWidget {
  const _TaskTile({
    required this.task,
    required this.showReopen,
    required this.onEdit,
    this.isOverdue = false,
  });

  final Task task;
  final bool showReopen;
  final VoidCallback onEdit;
  final bool isOverdue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final dao = ref.read(appDatabaseProvider).tasksDao;
    final isHigh = task.priority == 'high';
    final listMap = ref.watch(_taskListMapProvider).value ?? {};
    final taskList = task.listId != null ? listMap[task.listId] : null;
    final showingAllLists = ref.watch(_selectedListIdProvider) == null;

    String? subtitle;
    if (task.dueDate != null) {
      final d = DateTime.tryParse(task.dueDate!);
      if (d != null) {
        subtitle = DateFormat('EEE, d MMM').format(d);
        if (task.dueTime != null) subtitle += '  ${task.dueTime}';
      }
    }
    if (task.recurrence != 'none') {
      final rec = switch (task.recurrence) {
        'daily' => 'Daily',
        'weekly' => 'Weekly',
        'monthly' => 'Monthly',
        _ => '',
      };
      subtitle = subtitle != null ? '$subtitle · $rec' : rec;
    }
    if (task.note.isNotEmpty) {
      subtitle = subtitle != null ? '$subtitle\n${task.note}' : task.note;
    }
    // Show list name when viewing All Lists
    if (taskList != null && showingAllLists) {
      final tag = '${taskList.emoji} ${taskList.name}';
      subtitle = subtitle != null ? '$subtitle\n$tag' : tag;
    }

    final subtitleColor = isOverdue ? scheme.error : scheme.onSurfaceVariant;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: scheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete_outline, color: scheme.onErrorContainer),
      ),
      confirmDismiss: (_) async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete task?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete')),
            ],
          ),
        );
        return ok ?? false;
      },
      onDismissed: (_) async {
        await dao.deleteTask(task.id);
        await _cancelTaskNotif(task.id);
      },
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) async {
            if (task.isCompleted) {
              await dao.reopenTask(task.id);
            } else {
              await dao.completeTask(task.id);
              await _cancelTaskNotif(task.id);
              if (task.recurrence != 'none') {
                await _scheduleNextRecurrence(ref, task);
              }
            }
          },
          shape: const CircleBorder(),
        ),
        title: Text(
          task.title,
          style: text.bodyLarge?.copyWith(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted
                ? scheme.onSurfaceVariant
                : isOverdue
                    ? scheme.error
                    : null,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: text.bodySmall?.copyWith(color: subtitleColor))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHigh) Icon(Icons.flag_rounded, color: scheme.error, size: 18),
            if (showReopen)
              IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                tooltip: 'Reopen',
                onPressed: () => dao.reopenTask(task.id),
              )
            else
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: 'Edit',
                onPressed: onEdit,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _scheduleNextRecurrence(WidgetRef ref, Task task) async {
    if (task.dueDate == null) return;
    final current = DateTime.tryParse(task.dueDate!);
    if (current == null) return;
    final next = switch (task.recurrence) {
      'daily' => DateTime(current.year, current.month, current.day + 1),
      'weekly' => DateTime(current.year, current.month, current.day + 7),
      'monthly' => DateTime(current.year, current.month + 1, current.day),
      _ => null,
    };
    if (next == null) return;
    final nextStr =
        '${next.year.toString().padLeft(4, '0')}-${next.month.toString().padLeft(2, '0')}-${next.day.toString().padLeft(2, '0')}';
    final dao = ref.read(appDatabaseProvider).tasksDao;
    final newId = await dao.addTask(TasksCompanion.insert(
      title: task.title,
      dueDate: Value(nextStr),
      dueTime: Value(task.dueTime),
      priority: Value(task.priority),
      recurrence: Value(task.recurrence),
      note: Value(task.note),
      listId: Value(task.listId),
      createdAt: DateTime.now().toUtc(),
    ));
    final saved = await dao.getTask(newId);
    if (saved != null) await _scheduleTaskNotif(saved);
  }
}

// ── Add / Edit task dialog ────────────────────────────────────────────────────

class _TaskDialog extends ConsumerStatefulWidget {
  const _TaskDialog({this.existing});
  final Task? existing;

  @override
  ConsumerState<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends ConsumerState<_TaskDialog> {
  late final TextEditingController _title;
  late final TextEditingController _note;
  String _priority = 'normal';
  String _recurrence = 'none';
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  int? _listId;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _priority = e?.priority ?? 'normal';
    _recurrence = e?.recurrence ?? 'none';
    // For new tasks, pre-select current list filter; for edits keep existing.
    _listId = e != null ? e.listId : ref.read(_selectedListIdProvider);
    if (e?.dueDate != null) _dueDate = DateTime.tryParse(e!.dueDate!);
    if (e?.dueTime != null) {
      final parts = e!.dueTime!.split(':');
      if (parts.length >= 2) {
        _dueTime = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0);
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  String? get _dueDateStr {
    if (_dueDate == null) return null;
    return '${_dueDate!.year.toString().padLeft(4, '0')}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}';
  }

  String? get _dueTimeStr {
    if (_dueTime == null) return null;
    return '${_dueTime!.hour.toString().padLeft(2, '0')}:${_dueTime!.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.existing;
    final scheme = Theme.of(context).colorScheme;
    final lists = ref.watch(_taskListsProvider).value ?? [];

    return AlertDialog(
      title: Text(e == null ? 'New Task' : 'Edit Task'),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _title,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Note
            TextField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              minLines: 1,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),

            // List picker (only if lists exist)
            if (lists.isNotEmpty) ...[
              DropdownButtonFormField<int?>(
                value: lists.any((l) => l.id == _listId) ? _listId : null,
                decoration: const InputDecoration(
                  labelText: 'List',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('No list')),
                  ...lists.map((l) => DropdownMenuItem(
                        value: l.id,
                        child: Row(children: [
                          Text(l.emoji),
                          const SizedBox(width: 8),
                          Text(l.name),
                        ]),
                      )),
                ],
                onChanged: (v) => setState(() => _listId = v),
              ),
              const SizedBox(height: 12),
            ],

            // Priority
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Priority:'),
                ChoiceChip(
                  label: const Text('Normal'),
                  selected: _priority == 'normal',
                  onSelected: (_) => setState(() => _priority = 'normal'),
                ),
                ChoiceChip(
                  label: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.flag_rounded, size: 14, color: scheme.error),
                    const SizedBox(width: 4),
                    const Text('High'),
                  ]),
                  selected: _priority == 'high',
                  selectedColor: scheme.errorContainer,
                  onSelected: (_) => setState(() => _priority = 'high'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Due date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(_dueDate == null
                  ? 'No due date'
                  : DateFormat('EEE, d MMM yyyy').format(_dueDate!)),
              trailing: _dueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => setState(() {
                        _dueDate = null;
                        _dueTime = null;
                      }),
                    )
                  : null,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 1)),
                  lastDate:
                      DateTime.now().add(const Duration(days: 365 * 3)),
                );
                if (picked != null) setState(() => _dueDate = picked);
              },
            ),

            if (_dueDate != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time_outlined),
                title: Text(_dueTime == null
                    ? 'No time (no notification)'
                    : _dueTime!.format(context)),
                trailing: _dueTime != null
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _dueTime = null),
                      )
                    : null,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _dueTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _dueTime = picked);
                },
              ),

            const SizedBox(height: 8),

            // Recurrence
            DropdownButtonFormField<String>(
              value: _recurrence,
              decoration: const InputDecoration(
                labelText: 'Repeat',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(
                    value: 'none', child: Text('Does not repeat')),
                DropdownMenuItem(
                    value: 'daily', child: Text('Every day')),
                DropdownMenuItem(
                    value: 'weekly', child: Text('Every week')),
                DropdownMenuItem(
                    value: 'monthly', child: Text('Every month')),
              ],
              onChanged: (v) => setState(() => _recurrence = v ?? 'none'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (_title.text.trim().isEmpty) return;
            final companion = e != null
                ? TasksCompanion(
                    id: Value(e.id),
                    title: Value(_title.text.trim()),
                    note: Value(_note.text.trim()),
                    listId: Value(_listId),
                    dueDate: Value(_dueDateStr),
                    dueTime: Value(_dueTimeStr),
                    priority: Value(_priority),
                    recurrence: Value(_recurrence),
                    isCompleted: Value(e.isCompleted),
                    completedAt: Value(e.completedAt),
                    createdAt: Value(e.createdAt),
                  )
                : TasksCompanion.insert(
                    title: _title.text.trim(),
                    note: Value(_note.text.trim()),
                    listId: Value(_listId),
                    dueDate: Value(_dueDateStr),
                    dueTime: Value(_dueTimeStr),
                    priority: Value(_priority),
                    recurrence: Value(_recurrence),
                    createdAt: DateTime.now().toUtc(),
                  );
            Navigator.pop(context, companion);
          },
          child: Text(e == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}

// ── Add / Edit list dialog ────────────────────────────────────────────────────

class _ListDialog extends StatefulWidget {
  const _ListDialog({this.existing});
  final TaskList? existing;

  @override
  State<_ListDialog> createState() => _ListDialogState();
}

class _ListDialogState extends State<_ListDialog> {
  late final TextEditingController _name;
  late String _color;
  late String _emoji;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _color = e?.color ?? _kPresetColors[0];
    _emoji = e?.emoji ?? _kPresetEmojis[0];
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.existing;
    final scheme = Theme.of(context).colorScheme;
    final pickedColor = _hexColor(_color);

    return AlertDialog(
      title: Text(e == null ? 'New List' : 'Edit List'),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live preview chip
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: pickedColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: pickedColor, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_emoji,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      _name.text.isEmpty ? 'List Name' : _name.text,
                      style: TextStyle(
                          color: pickedColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'List name',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Emoji picker
            Text('Icon',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _kPresetEmojis
                  .map((em) => GestureDetector(
                        onTap: () => setState(() => _emoji = em),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: em == _emoji
                                ? scheme.primaryContainer
                                : scheme.surfaceContainerHighest,
                          ),
                          child: Text(em,
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Color picker
            Text('Color',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _kPresetColors
                  .map((hex) {
                    final c = _hexColor(hex);
                    final selected = hex == _color;
                    return GestureDetector(
                      onTap: () => setState(() => _color = hex),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c,
                          border: selected
                              ? Border.all(
                                  color: scheme.onSurface, width: 2.5)
                              : null,
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                      color: c.withValues(alpha: 0.5),
                                      blurRadius: 6)
                                ]
                              : null,
                        ),
                        child: selected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 18)
                            : null,
                      ),
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (_name.text.trim().isEmpty) return;
            final companion = e != null
                ? TaskListsCompanion(
                    id: Value(e.id),
                    name: Value(_name.text.trim()),
                    color: Value(_color),
                    emoji: Value(_emoji),
                    createdAt: Value(e.createdAt),
                  )
                : TaskListsCompanion.insert(
                    name: _name.text.trim(),
                    color: Value(_color),
                    emoji: Value(_emoji),
                    createdAt: DateTime.now().toUtc(),
                  );
            Navigator.pop(context, companion);
          },
          child: Text(e == null ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}
