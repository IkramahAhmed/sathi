import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../core/storage/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../khata/domain/entities/expense_category.dart';
import '../../../prayer/domain/entities/prayer_name.dart';
import '../../../prayer/presentation/l10n_helpers.dart';
import '../../data/task_reminders.dart';
import '../bill_prompt.dart';
import '../task_providers.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Today's date. Recomputed at midnight and whenever the app is resumed, so the
/// Overdue and Today lists never keep showing yesterday.
class _TodayKey extends Notifier<String> {
  @override
  String build() {
    ref.watch(appLifecycleProvider);
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final timer = Timer(nextMidnight.difference(now) + const Duration(seconds: 1), ref.invalidateSelf);
    ref.onDispose(timer.cancel);
    return dateKey(now);
  }
}

final _todayKeyProvider = NotifierProvider<_TodayKey, String>(_TodayKey.new);

String _tomorrowOf(String today) {
  final d = DateTime.parse(today);
  return dateKey(DateTime(d.year, d.month, d.day + 1));
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

  void select(int? id) => state = id;
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
  return ref.watch(appDatabaseProvider).tasksDao.watchOverdue(ref.watch(_todayKeyProvider), listId);
});

final _todayTasksProvider = StreamProvider<List<Task>>((ref) {
  final listId = ref.watch(_selectedListIdProvider);
  return ref.watch(appDatabaseProvider).tasksDao.watchToday(ref.watch(_todayKeyProvider), listId);
});

final _tomorrowTasksProvider = StreamProvider<List<Task>>((ref) {
  final listId = ref.watch(_selectedListIdProvider);
  return ref.watch(appDatabaseProvider).tasksDao.watchTomorrow(_tomorrowOf(ref.watch(_todayKeyProvider)), listId);
});

final _upcomingTasksProvider = StreamProvider<List<Task>>((ref) {
  final listId = ref.watch(_selectedListIdProvider);
  return ref.watch(appDatabaseProvider).tasksDao.watchUpcoming(ref.watch(_todayKeyProvider), listId);
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
            label: Text(AppLocalizations.of(context).filterAll),
            selected: selectedListId == null,
            onSelected: (_) =>
                ref.read(_selectedListIdProvider.notifier).select(null),
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
                      ref.read(_selectedListIdProvider.notifier).select(list.id),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: Text(AppLocalizations.of(context).taskNewList),
              onPressed: () => _showListDialog(context),
            ),
          ),
        ],
      ),
    );

    final segmented = Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
      child: SegmentedButton<_TaskTab>(
        segments: [
          ButtonSegment(
              value: _TaskTab.today,
              label: Text(AppLocalizations.of(context).taskTabToday),
              icon: Icon(Icons.today_outlined)),
          ButtonSegment(
              value: _TaskTab.upcoming,
              label: Text(AppLocalizations.of(context).taskTabUpcoming),
              icon: Icon(Icons.calendar_month_outlined)),
          ButtonSegment(
              value: _TaskTab.completed,
              label: Text(AppLocalizations.of(context).done),
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
            emptyMessage: AppLocalizations.of(context).taskEmptyUpcoming);
      case _TaskTab.completed:
        body = _TaskList(
            provider: _completedTasksProvider,
            emptyMessage: AppLocalizations.of(context).taskEmptyDone,
            showReopen: true);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).navTasks),
        centerTitle: false,
        backgroundColor: scheme.surface,
      ),
      body: Column(children: [listChips, segmented, Expanded(child: body)]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context).taskNew),
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
      await cancelTaskReminder(taskId);
    }
    final saved = await dao.getTask(taskId);
    if (saved != null) {
      await scheduleTaskReminder(saved, prayerTime: ref.read(prayerTimeResolverProvider));
    }
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
              title: Text(AppLocalizations.of(context).taskEditList),
              onTap: () => Navigator.pop(ctx, 'edit'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline,
                  color: Theme.of(ctx).colorScheme.error),
              title: Text(AppLocalizations.of(context).taskDeleteList,
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
                child: Text(AppLocalizations.of(context).cancel)),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(AppLocalizations.of(context).delete)),
          ],
        ),
      );
      if (confirm == true) {
        final db = ref.read(appDatabaseProvider);
        await db.tasksDao.unassignList(list.id);
        await db.taskListsDao.deleteList(list.id);
        if (ref.read(_selectedListIdProvider) == list.id) {
          ref.read(_selectedListIdProvider.notifier).select(null);
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
          AppLocalizations.of(context).taskEmptyToday,
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
            label: AppLocalizations.of(context).taskOverdueCount('${overdue.length}'),
            color: scheme.error,
          ),
          ...overdue.map((t) => _buildTile(t, isOverdue: true)),
          const Divider(height: 24),
        ],

        // Today
        if (today.isNotEmpty) ...[
          _SectionHeader(icon: Icons.today_outlined, label: AppLocalizations.of(context).taskTabToday),
          ...today.map((t) => _buildTile(t)),
        ] else if (overdue.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              AppLocalizations.of(context).taskNoneToday,
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
                    AppLocalizations.of(context).taskTomorrowCount('${tomorrow.length}'),
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
              await cancelTaskReminder(tasks[i].id);
              final saved = await dao.getTask(tasks[i].id);
              if (saved != null) {
      await scheduleTaskReminder(saved, prayerTime: ref.read(prayerTimeResolverProvider));
    }
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
        final anchor = PrayerName.values.where((p) => p.name == task.prayerAnchor).firstOrNull;
        if (anchor != null) {
          final l10n = AppLocalizations.of(context);
          final m = task.prayerOffset;
          final rel = m == 0
              ? l10n.taskOffsetAt
              : m < 0
                  ? l10n.taskOffsetBefore('${-m}')
                  : l10n.taskOffsetAfter('$m');
          subtitle += '  ${prayerLabel(l10n, anchor)} · $rel';
        }
      }
    }
    if (task.recurrence != 'none') {
      final rec = switch (task.recurrence) {
        'daily' => AppLocalizations.of(context).taskDailyShort,
        'weekly' => AppLocalizations.of(context).taskWeeklyShort,
        'monthly' => AppLocalizations.of(context).taskMonthlyShort,
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
            title: Text(AppLocalizations.of(context).taskDeleteConfirm),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(AppLocalizations.of(context).cancel)),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(AppLocalizations.of(context).delete)),
            ],
          ),
        );
        return ok ?? false;
      },
      onDismissed: (_) async {
        await dao.deleteTask(task.id);
        await cancelTaskReminder(task.id);
      },
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) async {
            final db = ref.read(appDatabaseProvider);
            if (task.isCompleted) {
              await reopenTask(db, task);
            } else {
              await completeTask(db, task);
              if (context.mounted) await offerBillToKhata(context, ref, task);
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
                tooltip: AppLocalizations.of(context).taskReopen,
                onPressed: () => reopenTask(ref.read(appDatabaseProvider), task),
              )
            else
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: AppLocalizations.of(context).edit,
                onPressed: onEdit,
              ),
          ],
        ),
      ),
    );
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
  String? _prayerAnchor;
  int _prayerOffset = 0;
  int _remindBefore = 0;
  late final TextEditingController _amount;
  ExpenseCategory _billCategory = ExpenseCategory.bills;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _note = TextEditingController(text: e?.note ?? '');
    _prayerAnchor = e?.prayerAnchor;
    _prayerOffset = e?.prayerOffset ?? 0;
    _remindBefore = e?.remindBefore ?? 0;
    _amount = TextEditingController(
      text: e?.amount == null ? '' : e!.amount!.toStringAsFixed(e.amount! % 1 == 0 ? 0 : 2),
    );
    _billCategory = ExpenseCategory.fromString(e?.billCategory ?? 'bills');
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
    _amount.dispose();
    super.dispose();
  }

  String? get _dueDateStr {
    if (_dueDate == null) return null;
    return '${_dueDate!.year.toString().padLeft(4, '0')}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}';
  }

  double? get _billAmount {
    final v = double.tryParse(_amount.text.trim());
    return v != null && v > 0 ? v : null;
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
      title: Text(e == null ? AppLocalizations.of(context).taskNew : AppLocalizations.of(context).taskEdit),
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).taskTitleLabel,
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).taskNoteLabel,
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),

            // List picker (only if lists exist)
            if (lists.isNotEmpty) ...[
              DropdownButtonFormField<int?>(
                value: lists.any((l) => l.id == _listId) ? _listId : null,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).taskListLabel,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text(AppLocalizations.of(context).taskNoList)),
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
                Text(AppLocalizations.of(context).taskPriority),
                ChoiceChip(
                  label: Text(AppLocalizations.of(context).taskPriorityNormal),
                  selected: _priority == 'normal',
                  onSelected: (_) => setState(() => _priority = 'normal'),
                ),
                ChoiceChip(
                  label: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.flag_rounded, size: 14, color: scheme.error),
                    const SizedBox(width: 4),
                    Text(AppLocalizations.of(context).taskPriorityHigh),
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
                  ? AppLocalizations.of(context).taskNoDueDate
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
                final now = DateTime.now();
                final initial = _dueDate ?? now;
                final yesterday = now.subtract(const Duration(days: 1));
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initial,
                  firstDate: initial.isBefore(yesterday) ? initial : yesterday,
                  lastDate:
                      DateTime.now().add(const Duration(days: 365 * 3)),
                );
                if (picked != null) setState(() => _dueDate = picked);
              },
            ),

            if (_dueDate != null) ...[
              Builder(builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.taskAtTime),
                      selected: _prayerAnchor == null,
                      onSelected: (_) => setState(() => _prayerAnchor = null),
                    ),
                    ChoiceChip(
                      label: Text(l10n.taskAroundPrayer),
                      selected: _prayerAnchor != null,
                      onSelected: (_) => setState(() {
                        _prayerAnchor ??= PrayerName.asr.name;
                        _dueTime = null;
                      }),
                    ),
                  ],
                );
              }),
              if (_prayerAnchor == null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time_outlined),
                  title: Text(_dueTime == null
                      ? AppLocalizations.of(context).taskNoTime
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
                )
              else
                Builder(builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  String offsetLabel(int m) => m == 0
                      ? l10n.taskOffsetAt
                      : m < 0
                          ? l10n.taskOffsetBefore('${-m}')
                          : l10n.taskOffsetAfter('$m');
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _prayerAnchor,
                          isExpanded: true,
                          decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                          items: [
                            for (final p in PrayerName.obligatory)
                              DropdownMenuItem(value: p.name, child: Text(prayerLabel(l10n, p))),
                          ],
                          onChanged: (v) => setState(() => _prayerAnchor = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _prayerOffset,
                          isExpanded: true,
                          decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                          items: [
                            for (final m in const [-30, -15, 0, 15, 30, 60])
                              DropdownMenuItem(value: m, child: Text(offsetLabel(m))),
                          ],
                          onChanged: (v) => setState(() => _prayerOffset = v ?? 0),
                        ),
                      ),
                    ],
                  );
                }),
              if (_dueTime != null || _prayerAnchor != null) ...[
                const SizedBox(height: 12),
                Builder(builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return DropdownButtonFormField<int>(
                    initialValue: _remindBefore,
                    decoration: InputDecoration(
                      labelText: l10n.taskRemindBefore,
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 0, child: Text(l10n.taskRemindNone)),
                      DropdownMenuItem(value: 10, child: Text(l10n.taskRemindMin('10'))),
                      DropdownMenuItem(value: 60, child: Text(l10n.taskRemindHour)),
                      DropdownMenuItem(value: 1440, child: Text(l10n.taskRemindDay)),
                    ],
                    onChanged: (v) => setState(() => _remindBefore = v ?? 0),
                  );
                }),
              ],
            ],

            const SizedBox(height: 12),

            // Bill amount
            Builder(builder: (context) {
              final l10n = AppLocalizations.of(context);
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amount,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.taskBillAmount,
                        prefixText: 'Rs. ',
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  if ((double.tryParse(_amount.text) ?? 0) > 0) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<ExpenseCategory>(
                        initialValue: _billCategory,
                        isExpanded: true,
                        decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                        items: [
                          for (final c in ExpenseCategory.values)
                            DropdownMenuItem(value: c, child: Text(c.label(l10n))),
                        ],
                        onChanged: (v) => setState(() => _billCategory = v ?? ExpenseCategory.bills),
                      ),
                    ),
                  ],
                ],
              );
            }),

            const SizedBox(height: 8),

            // Recurrence
            DropdownButtonFormField<String>(
              value: _recurrence,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).taskRepeat,
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: [
                DropdownMenuItem(
                    value: 'none', child: Text(AppLocalizations.of(context).taskRepeatNone)),
                DropdownMenuItem(
                    value: 'daily', child: Text(AppLocalizations.of(context).taskRepeatDaily)),
                DropdownMenuItem(
                    value: 'weekly', child: Text(AppLocalizations.of(context).taskRepeatWeekly)),
                DropdownMenuItem(
                    value: 'monthly', child: Text(AppLocalizations.of(context).taskRepeatMonthly)),
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
            child: Text(AppLocalizations.of(context).cancel)),
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
                    dueTime: Value(_prayerAnchor == null ? _dueTimeStr : null),
                    remindBefore: Value(_remindBefore),
                    prayerAnchor: Value(_prayerAnchor),
                    prayerOffset: Value(_prayerOffset),
                    amount: Value(_billAmount),
                    billCategory: Value(_billAmount == null ? null : _billCategory.name),
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
                    dueTime: Value(_prayerAnchor == null ? _dueTimeStr : null),
                    remindBefore: Value(_remindBefore),
                    prayerAnchor: Value(_prayerAnchor),
                    prayerOffset: Value(_prayerOffset),
                    amount: Value(_billAmount),
                    billCategory: Value(_billAmount == null ? null : _billCategory.name),
                    priority: Value(_priority),
                    recurrence: Value(_recurrence),
                    createdAt: DateTime.now().toUtc(),
                  );
            Navigator.pop(context, companion);
          },
          child: Text(e == null ? AppLocalizations.of(context).add : AppLocalizations.of(context).save),
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
      title: Text(e == null ? AppLocalizations.of(context).taskNewList : AppLocalizations.of(context).taskEditList),
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).taskListName,
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Emoji picker
            Text(AppLocalizations.of(context).taskIcon,
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
            child: Text(AppLocalizations.of(context).cancel)),
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
          child: Text(e == null ? AppLocalizations.of(context).taskCreate : AppLocalizations.of(context).save),
        ),
      ],
    );
  }
}
