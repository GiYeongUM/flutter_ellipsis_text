import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ellipsis_text/flutter_ellipsis_text.dart';

void main() {
  testWidgets(
    'reports expansion to accessibility and callbacks without motion',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final changes = <bool>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: SizedBox(
                width: 100,
                child: EllipsisText(
                  text: 'Long paragraph ' * 20,
                  ellipsis: '…',
                  onExpandedChanged: changes.add,
                ),
              ),
            ),
          ),
        ),
      );
      expect(
        tester
            .widget<Semantics>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is Semantics &&
                    widget.properties.label == 'Long paragraph ' * 20,
              ),
            )
            .properties
            .expanded,
        isFalse,
      );
      await tester.tap(find.byType(InkWell));
      await tester.pump();
      expect(changes, [true]);
      expect(find.byType(AnimatedCrossFade), findsNothing);
      expect(
        tester
            .widget<Semantics>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is Semantics &&
                    widget.properties.label == 'Long paragraph ' * 20,
              ),
            )
            .properties
            .expanded,
        isTrue,
      );
      final expandedText = tester.widget<Text>(
        find.text('Long paragraph ' * 20),
      );
      expect(expandedText.style!.color, isNot(Colors.black));
      semantics.dispose();
      expect(tester.takeException(), isNull);
    },
  );
}
