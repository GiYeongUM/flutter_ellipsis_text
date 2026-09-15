import 'package:flutter/painting.dart';

/// Owns a single paragraph used by both measurement and painting.
final class TextLayout {
  final _painter = TextPainter();
  Object? _configuration;
  int revision = 0;

  Size get size => _painter.size;
  bool get exceedsMaxLines => _painter.didExceedMaxLines;

  void update({
    required TextSpan text,
    required String ellipsis,
    required int maxLines,
    required TextDirection direction,
    required TextScaler textScaler,
    required double minWidth,
    required double maxWidth,
    required Locale? locale,
  }) {
    final configuration = (
      text,
      ellipsis,
      maxLines,
      direction,
      textScaler,
      minWidth,
      maxWidth,
      locale,
    );
    if (configuration == _configuration) return;
    _configuration = configuration;
    _painter
      ..text = text
      ..ellipsis = ellipsis
      ..maxLines = maxLines
      ..textDirection = direction
      ..textScaler = textScaler
      ..locale = locale
      ..layout(minWidth: minWidth, maxWidth: maxWidth);
    revision++;
  }

  void paint(Canvas canvas) => _painter.paint(canvas, Offset.zero);

  void dispose() => _painter.dispose();
}
