import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/prayer_providers.dart';

/// Live Qibla compass, with a text bearing as the fallback when the phone has
/// no compass sensor.
///
/// The bearing to the Kaaba comes from the saved location, so the screen works
/// offline and never asks for a GPS fix or any extra permission. Only the
/// heading comes from the sensor.
class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  late final Future<bool> _sensorSupport = _checkSensors();

  Future<bool> _checkSensors() async {
    try {
      if (FlutterCompass.events == null) return false;
      return await FlutterQiblah.androidDeviceSensorSupport() ?? true;
    } catch (_) {
      return false;
    }
  }

  /// Combines the sensor heading with the fixed bearing to the Kaaba.
  Stream<QiblahDirection> _directions(double bearing) =>
      FlutterCompass.events!.where((e) => e.heading != null).map((e) {
        final heading = (e.heading! + 360) % 360;
        // Same convention as flutter_qiblah: 0 means the phone faces the Kaaba.
        return QiblahDirection((heading + (360 - bearing)) % 360, heading, bearing);
      });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bearing = ref.watch(qiblaBearingProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.qiblaTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.qiblaBearing(bearing.round()),
                key: const ValueKey('qibla-bearing'),
                textAlign: TextAlign.center,
                style: text.titleLarge,
              ),
              const SizedBox(height: 24),
              FutureBuilder<bool>(
                future: _sensorSupport,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  if (snapshot.data == false) {
                    return _Fallback(message: l10n.qiblaNoSensor, bearing: bearing);
                  }
                  return StreamBuilder<QiblahDirection>(
                    stream: _directions(bearing),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return _Fallback(message: l10n.qiblaNoSensor, bearing: bearing);
                      }
                      if (!snap.hasData) return const CircularProgressIndicator();
                      return _Compass(direction: snap.data!, hint: l10n.qiblaFace);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A static arrow showing the bearing from north, plus an explanation.
class _Fallback extends StatelessWidget {
  const _Fallback({required this.message, required this.bearing});

  final String message;
  final double bearing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: _DialPainter(scheme.outline, scheme.onSurface),
            child: Center(
              child: Transform.rotate(
                angle: bearing * math.pi / 180,
                child: Icon(Icons.navigation, size: 96, color: scheme.primary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _Compass extends StatelessWidget {
  const _Compass({required this.direction, required this.hint});

  final QiblahDirection direction;
  final String hint;

  static double _rad(double degrees) => degrees * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // `qiblah` is (heading - bearing) mod 360: 0 means the phone faces the Kaaba.
    final offByDegrees = direction.qiblah % 360;
    final aligned = offByDegrees < 4 || offByDegrees > 356;
    return Column(
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The dial turns opposite to the phone so "N" stays on true north.
              Transform.rotate(
                angle: -_rad(direction.direction),
                child: CustomPaint(
                  size: const Size.square(260),
                  painter: _DialPainter(scheme.outline, scheme.onSurface),
                ),
              ),
              // The needle points at the Kaaba relative to the phone.
              Transform.rotate(
                angle: -_rad(direction.qiblah),
                child: Icon(
                  Icons.navigation,
                  size: 110,
                  color: aligned ? Colors.green : scheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(hint, textAlign: TextAlign.center),
      ],
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter(this.ring, this.label);

  final Color ring;
  final Color label;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 4;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = ring
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    for (var i = 0; i < 360; i += 30) {
      final a = (i - 90) * math.pi / 180;
      final long = i % 90 == 0;
      final inner = radius - (long ? 16 : 8);
      canvas.drawLine(
        center + Offset(math.cos(a), math.sin(a)) * radius,
        center + Offset(math.cos(a), math.sin(a)) * inner,
        Paint()
          ..color = ring
          ..strokeWidth = long ? 3 : 1.5,
      );
    }
    final painter = TextPainter(
      text: TextSpan(text: 'N', style: TextStyle(color: label, fontWeight: FontWeight.w700, fontSize: 16)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(center.dx - painter.width / 2, center.dy - radius + 20));
  }

  @override
  bool shouldRepaint(_DialPainter old) => old.ring != ring || old.label != label;
}
