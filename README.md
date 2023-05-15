# flutter_ellipsis_text

ellipsis text is a widget that allows you to **customize text in ellipsis** when text exceeds maxLines.

[![Flutter](https://img.shields.io/badge/Platform-Flutter-blue.svg)](https://flutter.dev/)


## ⚡ [Installation](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

```yaml
dependencies:
  flutter_icon_snackbar: ^<latest_version>
```

## 💪 Usage

<img width="308" alt="" src="https://github.com/GiYeongUM/flutter_ellipsis_text/raw/main/images/ellipsis_text.gif">

``` dart
EllipsisText(
    text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
        "when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
        "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
    ellipsis: "..show more",
    maxLines: 2,
    style: TextStyle(), // add if you want
)
```