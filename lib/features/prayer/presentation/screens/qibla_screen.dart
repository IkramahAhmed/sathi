import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart' hide TextDirection;

import '../../../../l10n/app_localizations.dart';
import '../../data/compass/compass_source.dart';
import '../../domain/entities/qibla.dart';
import '../providers/prayer_providers.dart';
import '../providers/qibla_providers.dart';

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
  late final Future<bool> _sensorSupport = ref.read(compassSourceProvider).available();
  Stream<CompassReading>? _readings;
  DateTime? _firstReading;

  Stream<CompassReading> _stream() => _readings ??= ref.read(compassSourceProvider).readings();

  /// The accuracy is unknown for the first moments after start; only call a reading
  /// poor when it says so, or has stayed unknown for a few seconds.
  bool _needsCalibration(CompassReading reading) {
    final accuracy = reading.accuracy;
    if (accuracy != null) return accuracy >= 45;
    final first = _firstReading ??= DateTime.now();
    return DateTime.now().difference(first) > const Duration(seconds: 4);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bearing = ref.watch(qiblaBearingProvider);
    final declination = ref.watch(magneticDeclinationProvider).value ?? 0;
    final km = ref.watch(kaabaDistanceKmProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.qiblaTitle)),
      body: Center(
        child: SingleChildScrollView(
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
              const SizedBox(height: 4),
              Text(
                l10n.qiblaDistance(NumberFormat.decimalPattern('en').format(km.round())),
                key: const ValueKey('qibla-distance'),
                style: text.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              FutureBuilder<bool>(
                future: _sensorSupport,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  if (snapshot.data == false) {
                    return _Fallback(message: l10n.qiblaNoSensor, bearing: bearing);
                  }
                  return StreamBuilder<CompassReading>(
                    stream: _stream(),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return _Fallback(message: l10n.qiblaNoSensor, bearing: bearing);
                      }
                      final reading = snap.data;
                      if (reading == null) return const CircularProgressIndicator();
                      final heading = trueHeading(reading.magneticHeading, declination);
                      return _Compass(
                        heading: heading,
                        bearing: bearing,
                        calibrate: _needsCalibration(reading),
                      );
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
  const _Compass({required this.heading, required this.bearing, required this.calibrate});

  /// Where the top of the phone points, degrees from true north.
  final double heading;

  /// Where the Kaaba is, degrees from true north.
  final double bearing;
  final bool calibrate;

  static double _rad(double degrees) => degrees * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final turn = turnToQibla(heading: heading, bearing: bearing);
    final facing = isFacingQibla(turn);
    final guidance = facing
        ? l10n.qiblaFacing
        : (turn > 0 ? l10n.qiblaTurnRight(turn.round()) : l10n.qiblaTurnLeft(turn.abs().round()));
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
                key: const ValueKey('qibla-dial'),
                angle: -_rad(heading),
                child: CustomPaint(
                  size: const Size.square(260),
                  painter: _DialPainter(scheme.outline, scheme.onSurface),
                ),
              ),
              // The needle points at the Kaaba relative to the top of the phone.
              Transform.rotate(
                key: const ValueKey('qibla-needle'),
                angle: _rad(bearing - heading),
                child: Icon(
                  Icons.navigation,
                  size: 110,
                  color: facing ? Colors.green : scheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          guidance,
          key: const ValueKey('qibla-guidance'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: facing ? Colors.green.shade700 : null,
                fontWeight: facing ? FontWeight.w700 : null,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.qiblaHeading(heading.round() % 360),
          key: const ValueKey('qibla-heading'),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        if (calibrate) ...[
          const SizedBox(height: 12),
          Text(
            l10n.qiblaCalibrate,
            key: const ValueKey('qibla-calibrate'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.error),
          ),
        ],
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
