import 'package:flutter/material.dart';
import 'package:flutter_ellipsis_text/flutter_ellipsis_text.dart';
import 'package:flutter_test/flutter_test.dart';

const longText =
    'A long sentence with enough words to span many lines. '
    'Another sentence that should become visible when the text expands.';

Widget host(
  Widget child, {
  double width = 160,
  TextDirection direction = TextDirection.ltr,
  double scale = 1,
}) => MaterialApp(
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Directionality(
          textDirection: direction,
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  ),
);

Finder get paintedText => find.byWidgetPredicate(
  (widget) => widget is CustomPaint && widget.painter is EllipsisTextPainter,
);

void main() {
  testWidgets('constrains default infinite width and expands on tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(const EllipsisText(text: longText, ellipsis: '… more')),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(paintedText).width, lessThanOrEqualTo(160));
    final collapsedHeight = tester.getSize(find.byType(EllipsisText)).height;
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(EllipsisText)).height,
      greaterThan(collapsedHeight),
    );
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(EllipsisText)).height,
      closeTo(collapsedHeight, 0.01),
    );
  });

  testWidgets('short and noninteractive text have no toggle', (tester) async {
    await tester.pumpWidget(
      host(const EllipsisText(text: 'Hello', ellipsis: '…')),
    );
    expect(find.byType(InkWell), findsNothing);
    await tester.pumpWidget(
      host(
        const EllipsisText(text: longText, ellipsis: '…', isShowMore: false),
      ),
    );
    expect(find.byType(InkWell), findsNothing);
    expect(tester.getSize(paintedText).width, lessThanOrEqualTo(160));
    expect(tester.takeException(), isNull);
  });

  testWidgets('inherits RTL and text scaling and exposes full semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      host(
        const EllipsisText(text: longText, ellipsis: '…', isShowMore: false),
        direction: TextDirection.rtl,
        scale: 2,
      ),
    );
    final painter =
        tester.widget<CustomPaint>(paintedText).painter! as EllipsisTextPainter;
    expect(painter.textDirection, TextDirection.rtl);
    expect(painter.textScaler.scale(10), 20);
    expect(find.bySemanticsLabel(longText), findsOneWidget);
    semantics.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('updates text and honors explicit width and direction', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const EllipsisText(
          text: longText,
          ellipsis: '…',
          maxWidth: 100,
          isShowMore: false,
        ),
      ),
    );
    final before =
        tester.widget<CustomPaint>(paintedText).painter! as EllipsisTextPainter;
    await tester.pumpWidget(
      host(
        const EllipsisText(
          text: 'Updated',
          ellipsis: '!',
          maxWidth: 100,
          isShowMore: false,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
    final after =
        tester.widget<CustomPaint>(paintedText).painter! as EllipsisTextPainter;
    expect(after.shouldRepaint(before), isTrue);
    expect(after.text.text, 'Updated');
    expect(after.textDirection, TextDirection.rtl);
    // A tight parent width wins over the child's preferred width.
    expect(tester.getSize(paintedText).width, 160);
    expect(tester.takeException(), isNull);
  });

  testWidgets('works without a bounded horizontal parent', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [const EllipsisText(text: 'Hello', ellipsis: '…')],
          ),
        ),
      ),
    );
    expect(tester.getSize(paintedText).width.isFinite, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('honors expanded initial state and changes to it', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const EllipsisText(
          text: longText,
          ellipsis: '…',
          startScaleIsSmall: false,
        ),
      ),
    );
    expect(
      tester
          .widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade))
          .crossFadeState,
      CrossFadeState.showSecond,
    );
    await tester.pumpWidget(
      host(const EllipsisText(text: longText, ellipsis: '…')),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade))
          .crossFadeState,
      CrossFadeState.showFirst,
    );
  });
}
