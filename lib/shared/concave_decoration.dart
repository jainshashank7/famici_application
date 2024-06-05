import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:ui' as ui;

class ConcaveDecoration extends Decoration {
  final ShapeBorder shape;
  final double depth;
  final List<Color> colors;
  final double opacity;
  final bool isDark;
  final bool inverse;
  const ConcaveDecoration({
    required this.shape,
    required this.depth,
    List<Color>? colors,
    this.opacity = 1.0,
    bool? isDark,
    bool? inverse,
  })  : isDark = isDark ?? false,
        colors = colors ?? const [Colors.black87, Colors.black87],
        inverse = inverse ?? false,
        assert(colors?.length == 2);

  @override
  BoxPainter createBoxPainter([Function? onChanged]) =>
      _ConcaveDecorationPainter(shape, depth, colors, opacity, isDark, inverse);

  @override
  EdgeInsetsGeometry get padding => shape.dimensions;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is ConcaveDecoration) {
      t = Curves.easeInOut.transform(t);
      return ConcaveDecoration(
        shape: ShapeBorder.lerp(a.shape, shape, t)!,
        depth: ui.lerpDouble(a.depth, depth, t)!,
        colors: [
          Color.lerp(a.colors[0], colors[0], t)!.withOpacity(0.6),
          Color.lerp(a.colors[1], colors[1], t)!,
        ],
        opacity: ui.lerpDouble(a.opacity, opacity, t)!,
      );
    }
    return null;
  }
}

class _ConcaveDecorationPainter extends BoxPainter {
  ShapeBorder shape;
  double depth;
  List<Color> colors;
  double opacity;
  bool isDark;
  bool inverse;

  _ConcaveDecorationPainter(
    this.shape,
    this.depth,
    this.colors,
    this.opacity,
    this.isDark,
    this.inverse,
  ) {
    if (depth > 0) {
      colors = [
        colors[0],
        colors[1],
      ];
    } else {
      depth = -depth;
    }
    colors = [
      colors[0].withOpacity(opacity),
      colors[1].withOpacity(opacity),
    ];
  }

  @override
  void paint(
      ui.Canvas canvas, ui.Offset offset, ImageConfiguration configuration) {
    final shapePath = shape.getOuterPath(offset & configuration.size!);
    final rect = shapePath.getBounds();

    final delta = 16 / rect.longestSide;
    final stops = [0.5 - delta, 0.5 + delta];

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(depth * 2))
      ..addPath(shapePath, Offset.zero);
    canvas.save();
    canvas.clipPath(shapePath);

    final paint = Paint()
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        depth,
      );
    final clipSize = rect.size.aspectRatio > 1
        ? Size(rect.width, rect.height / 2)
        : Size(rect.width, rect.height);

    for (final alignment in [
      inverse ? Alignment.topLeft : Alignment.bottomRight,
      inverse ? Alignment.bottomRight : Alignment.topLeft
    ]) {
      final shaderRect = alignment.inscribe(
        Size.square(rect.longestSide),
        rect,
      );
      List<Color> _colors = [];

      for (int i = 0; i < colors.length; i++) {
        if (i == 0) {
          _colors.add(colors[i].withOpacity(isDark ? 0.8 : 0.3));
        } else {
          _colors.add(colors[i].withOpacity(isDark ? 1 : 0.5));
        }
      }
      paint.shader = ui.Gradient.linear(
        inverse ? shaderRect.topLeft : shaderRect.bottomRight,
        inverse ? shaderRect.bottomRight : shaderRect.topLeft,
        _colors,
        stops,
      );

      canvas.save();
      canvas.clipRect(alignment.inscribe(clipSize, rect));
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    canvas.restore();
  }
}
