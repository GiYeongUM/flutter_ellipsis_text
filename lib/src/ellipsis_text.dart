import 'package:flutter/material.dart';
import 'rendering/ellipsis_text_painter.dart';
import 'rendering/text_layout.dart';

/// Text with a custom ellipsis and an optional expand/collapse interaction.
class EllipsisText extends StatefulWidget {
  const EllipsisText({
    super.key,
    required this.text,
    required this.ellipsis,
    this.style,
    this.maxWidth = double.infinity,
    this.minWidth = 0,
    this.maxLines = 2,
    this.textDirection,
    this.expandable = true,
    this.initiallyCollapsed = true,
    this.duration = const Duration(milliseconds: 300),
    this.onExpandedChanged,
    this.splashFactory,
  }) : assert(maxLines > 0),
       assert(minWidth >= 0 && minWidth < double.infinity),
       assert(maxWidth >= minWidth);

  final String text;
  final String ellipsis;
  final TextStyle? style;
  final double maxWidth;
  final double minWidth;
  final int maxLines;
  final TextDirection? textDirection;
  final bool expandable;
  final bool initiallyCollapsed;
  final Duration duration;
  final ValueChanged<bool>? onExpandedChanged;
  final InteractiveInkFeatureFactory? splashFactory;

  @override
  State<EllipsisText> createState() => _EllipsisTextState();
}

class _EllipsisTextState extends State<EllipsisText> {
  final _layout = TextLayout();
  late bool _collapsed = widget.initiallyCollapsed;

  @override
  void didUpdateWidget(covariant EllipsisText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyCollapsed != widget.initiallyCollapsed) {
      _collapsed = widget.initiallyCollapsed;
    }
  }

  void _toggle() {
    setState(() => _collapsed = !_collapsed);
    widget.onExpandedChanged?.call(!_collapsed);
  }

  @override
  Widget build(BuildContext context) {
    final direction = widget.textDirection ?? Directionality.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final ambientStyle = DefaultTextStyle.of(context).style;
    final style = widget.style?.inherit == false
        ? widget.style!
        : ambientStyle.merge(widget.style);
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : widget.duration;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth,
        maxWidth: widget.maxWidth,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _layout.update(
            text: TextSpan(text: widget.text, style: style),
            ellipsis: widget.ellipsis,
            maxLines: widget.maxLines,
            direction: direction,
            textScaler: textScaler,
            minWidth: constraints.minWidth,
            maxWidth: constraints.maxWidth,
            locale: Localizations.maybeLocaleOf(context),
          );
          final collapsed = CustomPaint(
            size: _layout.size,
            painter: EllipsisTextPainter(_layout),
          );
          final canToggle = widget.expandable && _layout.exceedsMaxLines;
          final expanded = Text(
            widget.text,
            style: style,
            textDirection: direction,
            textScaler: textScaler,
          );
          return Semantics(
            label: widget.text,
            textDirection: direction,
            button: canToggle,
            expanded: canToggle ? !_collapsed : null,
            onTap: canToggle ? _toggle : null,
            child: ExcludeSemantics(
              child: canToggle
                  ? InkWell(
                      splashFactory: widget.splashFactory,
                      onTap: _toggle,
                      child: duration == Duration.zero
                          ? (_collapsed ? collapsed : expanded)
                          : AnimatedCrossFade(
                              duration: duration,
                              crossFadeState: _collapsed
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: collapsed,
                              secondChild: expanded,
                            ),
                    )
                  : collapsed,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _layout.dispose();
    super.dispose();
  }
}
