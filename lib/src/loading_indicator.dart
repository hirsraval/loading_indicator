import 'dart:math' as math;

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _LoadingIndicator(size: 48, color: color),
    );
  }
}

const double _kGapAngle = math.pi / 6;
const double _kMinAngle = math.pi / 36;

class _LoadingIndicator extends StatefulWidget {
  final Color? color;

  final double size;

  const _LoadingIndicator({required this.size, this.color});

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

  late final _firstRotationAnimation = Tween<double>(begin: 0, end: 4 * math.pi / 3)
      .animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)));
  late final _secondRotationAnimation = Tween<double>(
          begin: 4 * math.pi / 3, end: (4 * math.pi / 3) + (2 * math.pi / 3))
      .animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.5, 1.0, curve: Curves.easeInOut)));
  late final _firstArcAnimation = Tween<double>(begin: 2 * math.pi / 3 - _kGapAngle, end: _kMinAngle)
      .animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.4, curve: Curves.easeInOut)));
  late final _secondArcAnimation = Tween<double>(begin: _kMinAngle, end: 2 * math.pi / 3 - _kGapAngle)
      .animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.5, 0.9, curve: Curves.easeInOut)));

  @override
  void initState() {
    super.initState();
    _animationController.repeat();
    _animationController.addListener(_animationListener);
  }

  void _animationListener() {
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    final double size = widget.size;
    final double ringWidth = size * 0.10;

    final effectiveRotationValue =
        (_animationController.value <= 0.5 ? _firstRotationAnimation : _secondRotationAnimation).value;
    final effectiveEndAngleValue = (_animationController.value <= 0.5 ? _firstArcAnimation : _secondArcAnimation).value;

    return SizedBox.square(
      dimension: size,
      child: Transform.rotate(
        angle: effectiveRotationValue,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _Arc(
              color: color,
              size: size,
              strokeWidth: ringWidth,
              startAngle: 7 * math.pi / 6,
              endAngle: effectiveEndAngleValue,
            ),
            _Arc(
              color: color,
              size: size,
              strokeWidth: ringWidth,
              startAngle: math.pi / 2,
              endAngle: effectiveEndAngleValue,
            ),
            _Arc(
              color: color,
              size: size,
              strokeWidth: ringWidth,
              startAngle: -math.pi / 6,
              endAngle: effectiveEndAngleValue,
            ),
          ],
        ),
      ),
    );
  }
}

class _Arc extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  final double startAngle;
  final double endAngle;

  const _Arc({
    required this.color,
    required this.size,
    required this.strokeWidth,
    required this.startAngle,
    required this.endAngle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ArcPainter._(
          color,
          strokeWidth,
          startAngle,
          endAngle,
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color _color;
  final double _strokeWidth;
  final double _sweepAngle;
  final double _startAngle;

  const _ArcPainter._(
    this._color,
    this._strokeWidth,
    this._startAngle,
    this._sweepAngle,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.height / 2,
    );

    const bool useCenter = false;
    final Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    canvas.drawArc(rect, _startAngle, _sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
