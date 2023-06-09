library flutter_ellipsis_text;

import 'package:flutter/material.dart';

class EllipsisText extends StatefulWidget {
  const EllipsisText({
    Key? key,
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
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final String ellipsis;
  final int maxLines;
  final double maxWidth, minWidth;
  final TextDirection? textDirection;
  final bool isShowMore;
  final bool startScaleIsSmall;
  final InteractiveInkFeatureFactory? splashFactory;

  @override
  State<EllipsisText> createState() => _EllipsisTextState();
}

class _EllipsisTextState extends State<EllipsisText> {
  late bool isSmallContent = widget.startScaleIsSmall;

  @override
  void initState() {
    super.initState();
  }

  static Size getTextSize({
    required String text,
    required TextStyle style,
    int? maxLines,
    TextDirection? textDirection,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines ?? 1,
      textDirection: textDirection ?? TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static double getTextLineHeight({
    required int lines,
    required TextStyle style,
    TextDirection? textDirection,
  }) {
    return getTextSize(
      text: '\n' * lines,
      maxLines: lines,
      style: style,
      textDirection: textDirection,
    ).height;
  }

  @override
  Widget build(BuildContext context) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: widget.maxLines,
      textDirection: widget.textDirection ?? TextDirection.ltr,
    )..layout(minWidth: widget.minWidth, maxWidth: widget.maxWidth);

    return widget.isShowMore
        ? LayoutBuilder(builder: (context, size) {
            var span = TextSpan(
              text: widget.text,
              style: widget.style,
            );

            var tp = TextPainter(
              maxLines: widget.maxLines,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              text: span,
            );

            tp.layout(maxWidth: size.maxWidth);

            var exceeded = tp.didExceedMaxLines;

            return exceeded ? InkWell(
                    splashFactory: widget.splashFactory,
                    onTap: () {
                      setState(() {
                        isSmallContent = !isSmallContent;
                      });
                    },
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: isSmallContent
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: CustomPaint(
                          size: Size(
                              textPainter.size.width,
                              getTextLineHeight(
                                  style: widget.style,
                                  lines: widget.maxLines)),
                          painter: EllipsisTextPainter(
                            text: TextSpan(text: widget.text, style: widget.style),
                            ellipsis: widget.ellipsis,
                            maxLines: widget.maxLines,
                          )),
                      secondChild: Text(widget.text, style: widget.style),
                    ),
                  )
                : Text(widget.text, style: widget.style);
          })
        : CustomPaint(
            size: textPainter.size,
            painter: EllipsisTextPainter(
              text: TextSpan(text: widget.text, style: widget.style),
              ellipsis: widget.ellipsis,
              maxLines: widget.maxLines,
            ));
  }
}

class EllipsisTextPainter extends CustomPainter {
  final TextSpan text;
  final int maxLines;
  final String ellipsis;

  EllipsisTextPainter({
    required this.text,
    required this.ellipsis,
    required this.maxLines,
  }) : super();

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    TextPainter painter = TextPainter(
      text: text,
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..ellipsis = ellipsis;

    painter.layout(maxWidth: size.width);
    painter.paint(canvas, const Offset(0, 0));
  }
}
