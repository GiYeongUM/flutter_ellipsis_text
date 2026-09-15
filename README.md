# flutter_ellipsis_text

Expandable Flutter text with a custom ellipsis. Layout follows parent constraints,
text scaling, and ambient text direction.

## Installation

Requires Flutter 3.32+ and Dart 3.8+.

```sh
flutter pub add flutter_ellipsis_text
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_ellipsis_text/flutter_ellipsis_text.dart';

const EllipsisText(
  text: 'A long description that can be expanded by tapping it.',
  ellipsis: '… more',
  maxLines: 2,
  style: TextStyle(fontSize: 16),
)
```

Place the widget below a Material widget (for example, in a Scaffold).
Give it a bounded width with a SizedBox or Expanded when you want wrapping.

- Tap overflowing text to expand or collapse.
- Set `isShowMore: false` to display noninteractive, truncated text.
- Set `startScaleIsSmall: false` to start expanded.
- Set `textDirection` to override the ambient direction.
- `minWidth` and `maxWidth` are preferred constraints; tighter parent constraints win.

The full text remains available to screen readers when collapsed.

![Expand and collapse example](https://github.com/GiYeongUM/flutter_ellipsis_text/raw/main/images/ellipsis_text.gif)

## Development

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib example test
flutter analyze --fatal-infos
flutter test
flutter pub publish --dry-run
```

CI checks the minimum supported Flutter version and the latest stable channel.

## Migration

This release requires Dart 3.8 and Flutter 3.32 or newer. Existing constructor
and method arguments remain supported. See [CHANGELOG.md](CHANGELOG.md) for fixes.

## License

MIT. See [LICENSE](LICENSE).
