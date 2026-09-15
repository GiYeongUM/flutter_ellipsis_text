# Migrating to flutter_ellipsis_text 2.0

[← README](README.md) · [Release history](CHANGELOG.md)

Flutter 3.32 and Dart 3.8 remain the minimum supported versions. Update the dependency
to `flutter_ellipsis_text: ^2.0.0`, apply the changes below, then run `flutter analyze`
and your application's tests.

## Rename the expansion options

| 1.x                               | 2.0                                        |
| --------------------------------- | ------------------------------------------ |
| isShowMore                        | expandable                                 |
| startScaleIsSmall                 | initiallyCollapsed                         |
| Non-null style with black default | Optional style inheriting DefaultTextStyle |
| Exported EllipsisTextPainter      | Internal rendering implementation          |

### Before

```dart
EllipsisText(
  text: description,
  ellipsis: '… more',
  isShowMore: true,
  startScaleIsSmall: false,
)
```

### After

```dart
EllipsisText(
  text: description,
  ellipsis: '… more',
  expandable: true,
  initiallyCollapsed: false,
  onExpandedChanged: (expanded) {
    // Respond to a user-triggered state change.
  },
)
```

Set an explicit TextStyle color if you need the old fixed-color appearance. Changing
initiallyCollapsed resets the widget's state; the callback only reports user-triggered
toggles. Use the public widget rather than importing from src/.

## Verification checklist

- Check light and dark themes with your app's color scheme.
- Check large text and narrow layouts.
- Check right-to-left layouts where applicable.
- Check screen-reader labels and reduced-motion behavior.
- Run application tests after updating call sites.
