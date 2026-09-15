import 'package:flutter/rendering.dart';
import 'text_layout.dart';

/// Paints the paragraph already measured during layout.
final class EllipsisTextPainter extends CustomPainter {
  EllipsisTextPainter(this.layout) : revision = layout.revision;

  final TextLayout layout;
  final int revision;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    layout.paint(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant EllipsisTextPainter oldDelegate) =>
      layout != oldDelegate.layout || revision != oldDelegate.revision;
}
