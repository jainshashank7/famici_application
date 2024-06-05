import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:famici/utils/config/color_pallet.dart';

class RadialGuage extends StatefulWidget {
  const RadialGuage({
    Key? key,
    double? height,
    double? width,
    double? current,
    double? max,
  })  : height = height ?? 100,
        width = width ?? 100,
        current = current ?? 70,
        max = max ?? 100,
        super(key: key);

  final double height;
  final double width;
  final double current;
  final double max;

  @override
  _RadialGuageState createState() => _RadialGuageState();
}

class _RadialGuageState extends State<RadialGuage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  double _fraction = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get height => widget.height;
  double get width => widget.width;
  double get current => widget.current;
  double get max => widget.max;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomPaint(
        foregroundPainter: _MyCustomRadialGaugePainter(_fraction, max, current),
      ),
    );
  }
}

class _MyCustomRadialGaugePainter extends CustomPainter {
  final num maxValue;
  final num current;

  double _fraction;

  _MyCustomRadialGaugePainter(this._fraction, this.maxValue, this.current);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFFE9E9E9)
      ..shader = ui.Gradient.linear(
        ui.Offset(0, size.height / 2),
        ui.Offset(size.width, size.height / 2),
        [
          Colors.red,
          Colors.yellow,
          Colors.yellow,
          Colors.green,
        ],
        [0, 0.4, 0.7, 1],
      )
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height);

    const startAngle = -7 * pi / 6;
    const sweepAngle = 4 * pi / 3;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      line,
    );

    final arcAngle = (sweepAngle) * (current / maxValue);

    final p1 = Offset(
      center.dx +
          (radius - 10) * cos(-pi / 2 + (arcAngle * _fraction - 4 * pi / 6)),
      center.dy +
          (radius - 10) * sin(-pi / 2 + (arcAngle * _fraction - 4 * pi / 6)),
    );

    final p2 = Offset(
      center.dx +
          (radius + 10) * cos(-pi / 2 + (arcAngle * _fraction - 4 * pi / 6)),
      center.dy +
          (radius + 10) * sin(-pi / 2 + (arcAngle * _fraction - 4 * pi / 6)),
    );

    canvas.drawLine(
      p2,
      p1,
      Paint()
        ..strokeWidth = 8
        ..color = Color(0xFF5C5C5C)
        ..strokeCap = ui.StrokeCap.round
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_MyCustomRadialGaugePainter oldDelegate) =>
      oldDelegate._fraction != _fraction;
}
