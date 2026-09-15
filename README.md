# flutter_ellipsis_text

Expandable text that belongs in your app.

[![pub package](https://img.shields.io/pub/v/flutter_ellipsis_text.svg)](https://pub.dev/packages/flutter_ellipsis_text)
[![CI](https://github.com/GiYeongUM/flutter_ellipsis_text/actions/workflows/ci.yml/badge.svg)](https://github.com/GiYeongUM/flutter_ellipsis_text/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

[Quick start](#quick-start) · [Configuration](#configuration) ·
[Example](example/example.dart) · [Migration](MIGRATION.md) · [Changelog](CHANGELOG.md)

## At a glance

- Custom ellipsis with tap-to-expand and tap-to-collapse.
- Ambient typography, dark mode, text scaling, locale, and RTL support.
- A reusable paragraph for both measurement and painting.
- Screen-reader expansion state, callbacks, and reduced-motion support.

## Quick start

**Requirements:** Flutter **3.32+** · Dart **3.8+**

```sh
flutter pub add flutter_ellipsis_text
```

To use this major version explicitly:

```yaml
dependencies:
  flutter_ellipsis_text: ^2.0.0
```

```dart
import 'package:flutter_ellipsis_text/flutter_ellipsis_text.dart';

const EllipsisText(
  text: 'A longer description that readers can expand when they want more detail.',
  ellipsis: '… more',
  maxLines: 2,
)
```

## Configuration

| Option              | Default          | Purpose                                                    |
| ------------------- | ---------------- | ---------------------------------------------------------- |
| text / ellipsis     | required         | Full text and custom truncation marker.                    |
| style               | DefaultTextStyle | Optional typography override.                              |
| maxLines            | 2                | Maximum number of collapsed lines.                         |
| minWidth / maxWidth | 0 / infinity     | Preferred constraints; parent constraints take precedence. |
| textDirection       | Directionality   | Optional LTR/RTL override.                                 |
| expandable          | true             | Enable tap-to-expand for overflowing text.                 |
| initiallyCollapsed  | true             | Initial state; changing this property resets expansion.    |
| duration            | 300 ms           | Expand/collapse transition duration.                       |
| onExpandedChanged   | null             | Receives true after expansion and false after collapse.    |
| splashFactory       | theme default    | Optional ink effect.                                       |

## Layout and accessibility

Place interactive text beneath a `Material` widget, such as a `Scaffold`. Use
`SizedBox`, `Expanded`, or another bounded parent when you want wrapping. An unbounded
horizontal parent measures the text at its natural width.

The complete string is exposed to screen readers even when visually truncated. When
expansion is available, semantics also expose the current expanded state.
`MediaQuery.disableAnimations` makes expansion immediate.

## Package structure

```text
lib/
├── flutter_ellipsis_text.dart   # Public exports
└── src/
    ├── ellipsis_text.dart       # Widget, expansion state, and semantics
    └── rendering/
        ├── text_layout.dart    # Cached paragraph and layout
        └── ellipsis_text_painter.dart
```

Import the package entry point. Files under `src/` are implementation details and are
not a supported import surface.

## Development

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib example test
flutter analyze --fatal-infos
flutter test
flutter pub publish --dry-run
```

CI validates Flutter 3.32.0 and the latest stable channel. When switching SDK versions
locally, run `flutter clean` before testing to avoid reusing incompatible compiled
shader assets.

## Upgrading from 1.x

Version 2.0 includes intentional API changes. Follow [MIGRATION.md](MIGRATION.md) before
changing an existing application's dependency constraint.

## Support and license

Report reproducible issues in
[GitHub Issues](https://github.com/GiYeongUM/flutter_ellipsis_text/issues). Include the
Flutter version and a minimal example.

Released under the [MIT license](LICENSE).
