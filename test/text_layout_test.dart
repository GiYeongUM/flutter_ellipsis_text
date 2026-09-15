import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ellipsis_text/src/rendering/text_layout.dart';

void main() {
  test(
    'reuses an unchanged paragraph and invalidates on width or style changes',
    () {
      final layout = TextLayout();
      addTearDown(layout.dispose);
      void update(double width, {double fontSize = 14}) => layout.update(
        text: TextSpan(
          text: 'A paragraph of text that wraps onto more lines.',
          style: TextStyle(fontSize: fontSize),
        ),
        ellipsis: '…',
        maxLines: 2,
        direction: TextDirection.ltr,
        textScaler: TextScaler.noScaling,
        minWidth: 0,
        maxWidth: width,
        locale: null,
      );
      update(120);
      final revision = layout.revision;
      update(120);
      expect(layout.revision, revision);
      update(60);
      expect(layout.revision, revision + 1);
      update(60, fontSize: 24);
      expect(layout.revision, revision + 2);
    },
  );
}
