import 'package:flutter/material.dart';

/// Text with a custom ellipsis that can be tapped to expand or collapse.
///
/// Respects parent constraints, ambient text scaling, and text direction.
/// Place inside a [Material] when [isShowMore] is enabled for ink feedback.
class EllipsisText extends StatefulWidget {
  const EllipsisText({
    super.key,
    required this.text,
    required this.ellipsis,
    this.style = const TextStyle(color: Colors.black),
    this.maxWidth = double.infinity,
    this.minWidth = 0,
    this.maxLines = 2,
    this.textDirection,
    this.isShowMore = true,
    this.startScaleIsSmall = true,
    this.splashFactory,
  }) : assert(maxLines > 0),
       assert(minWidth >= 0 && minWidth < double.infinity),
       assert(maxWidth >= minWidth);

  final String text;
  final TextStyle style;
  final String ellipsis;
  final int maxLines;
  final double maxWidth;
  final double minWidth;
  final TextDirection? textDirection;
  final bool isShowMore;
  final bool startScaleIsSmall;
  final InteractiveInkFeatureFactory? splashFactory;

  @override
  State<EllipsisText> createState() => _EllipsisTextState();
}

class _EllipsisTextState extends State<EllipsisText> {
  late bool _isCollapsed = widget.startScaleIsSmall;

  @override
  void didUpdateWidget(covariant EllipsisText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startScaleIsSmall != widget.startScaleIsSmall) {
      _isCollapsed = widget.startScaleIsSmall;
    }
  }

  @override
  Widget build(BuildContext context) {
    final direction = widget.textDirection ?? Directionality.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final style = DefaultTextStyle.of(context).style.merge(widget.style);
    final span = TextSpan(text: widget.text, style: style);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth,
        maxWidth: widget.maxWidth,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final measurement =
              TextPainter(
                text: span,
                maxLines: widget.maxLines,
                ellipsis: widget.ellipsis,
                textDirection: direction,
                textScaler: textScaler,
              )..layout(
                minWidth: constraints.minWidth,
                maxWidth: constraints.maxWidth,
              );
          final size = measurement.size;
          final exceedsMaxLines = measurement.didExceedMaxLines;
          measurement.dispose();

          final collapsed = CustomPaint(
            size: size,
            painter: EllipsisTextPainter(
              text: span,
              ellipsis: widget.ellipsis,
              maxLines: widget.maxLines,
              textDirection: direction,
              textScaler: textScaler,
            ),
          );

          final canToggle = widget.isShowMore && exceedsMaxLines;
          return Semantics(
            label: widget.text,
            textDirection: direction,
            child: canToggle
                ? InkWell(
                    splashFactory: widget.splashFactory,
                    onTap: () => setState(() => _isCollapsed = !_isCollapsed),
                    child: ExcludeSemantics(
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: _isCollapsed
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: collapsed,
                        secondChild: Text(
                          widget.text,
                          style: style,
                          textDirection: direction,
                          textScaler: textScaler,
                        ),
                      ),
                    ),
                  )
                : collapsed,
          );
        },
      ),
    );
  }
}

/// Paints text using a custom ellipsis and the supplied layout settings.
class EllipsisTextPainter extends CustomPainter {
  EllipsisTextPainter({
    required this.text,
    required this.ellipsis,
    required this.maxLines,
    this.textDirection = TextDirection.ltr,
    this.textScaler = TextScaler.noScaling,
  }) : assert(maxLines > 0);

  final TextSpan text;
  final int maxLines;
  final String ellipsis;
  final TextDirection textDirection;
  final TextScaler textScaler;

  @override
  bool shouldRepaint(covariant EllipsisTextPainter oldDelegate) =>
      text != oldDelegate.text ||
      maxLines != oldDelegate.maxLines ||
      ellipsis != oldDelegate.ellipsis ||
      textDirection != oldDelegate.textDirection ||
      textScaler != oldDelegate.textScaler;

  @override
  void paint(Canvas canvas, Size size) {
    final painter = TextPainter(
      text: text,
      maxLines: maxLines,
      ellipsis: ellipsis,
      textDirection: textDirection,
      textScaler: textScaler,
    );
    try {
      painter.layout(maxWidth: size.width);
      painter.paint(canvas, Offset.zero);
    } finally {
      painter.dispose();
    }
  }
}
