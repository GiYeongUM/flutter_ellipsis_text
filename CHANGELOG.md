# Changelog

[← README](README.md) · [Migration guide](MIGRATION.md)

## 2.0.0

### Changed

- Separate the public widget, reusable text layout, and internal paint delegate.
- Reuse a TextPainter between measurement and painting instead of laying out the same
  paragraph twice.
- Follow inherited typography, locale, text scaling, and text direction.
- Expose expansion semantics, onExpandedChanged, duration, and reduced-motion support.

### Migration

- This major release intentionally changes public APIs; see
  [MIGRATION.md](MIGRATION.md).
- Minimum requirements remain Flutter 3.32 and Dart 3.8.

### Documentation

- Refresh examples, configuration tables, architecture notes, and migration
  instructions.

## 1.1.0

- Require Dart 3.8 and Flutter 3.32 or newer; adopt flutter_lints 6.
- Fix constrained layout, ambient text scaling, and right-to-left rendering.
- Repaint when text or styling changes and dispose temporary text painters.
- Add widget regression tests, CI, and corrected installation instructions.

## 1.0.1

- fix library

## 1.0.0

- publish project on pub.dev
- project Separation
