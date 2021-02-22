# keep_keyboard_popup_menu

A popup menu that will keep the soft keyboard open. This package is created to solve issue [#24843](https://github.com/flutter/flutter/issues/24843) and [#50567](https://github.com/flutter/flutter/issues/50567).

<img src="https://raw.githubusercontent.com/PegasisForever/keep_keyboard_popup_menu/master/example/screenshots/1.gif" width="200"/>

# How Does It work?

Unlike the popup menu created by [`PopupMenuButton`](https://api.flutter.dev/flutter/material/PopupMenuButton-class.html), which works by pushing
a new route to the navigator and causes the soft keyboard to hide, the popup
menu created by this package works by adding an entry to
[`Overlay`](https://api.flutter.dev/flutter/widgets/Overlay-class.html) and will keep the soft keyboard open.

# Quick Start

(I'm sorry for the long names, please pr if there are shorter alternatives.)

## `KeepKeyboardPopupMenuItem`

Intended to replace [`PopupMenuItem`](https://api.flutter.dev/flutter/material/PopupMenuItem-class.html). Works similarly to a [`ListTile`](https://api.flutter.dev/flutter/material/ListTile-class.html). [`PopupMenuItem`](https://api.flutter.dev/flutter/material/PopupMenuItem-class.html) won't work with this package because it will pop the current route when tapped. (This package shows popup menu using overlay, not route.)

```dart
KeepKeyboardPopupMenuItem(
    child: Text('awa'),
    onTap: () {},
);
```

## `KeepKeyboardPopupMenuButton`

Intended to replace [`PopupMenuButton`](https://api.flutter.dev/flutter/material/PopupMenuButton-class.html). Despite the similar name, the usage is quite different. The `closePopup` passed to the `menuItemBuilder` is used to programmatically close the popup.

```dart
KeepKeyboardPopupMenuButton(
    menuItemBuilder: (context, closePopup) => [
        KeepKeyboardPopupMenuItem(
            child: Text('awa'),
            onTap: closePopup,
        ),
    ]
)
```

You can also use the `menuBuilder` property to show any widget you want in the popup menu. For details, see the documentation and example.

## `WithKeepKeyboardPopupMenu`

`WithKeepKeyboardPopupMenu` allows opening a popup menu on any widget.

```dart
WithKeepKeyboardPopupMenu(
    menuItemBuilder: (context, closePopup) => [
        KeepKeyboardPopupMenuItem(
            child: Text('awa'),
            onTap: closePopup,
        ),
    ],
    childBuilder: (context, openPopup) => ElevatedButton(
        onPressed: openPopup,
        child: Text('Custom Trigger'),
    ),
    
)
```

You can also use the `menuBuilder` property to show any widget you want in the popup menu, use `backgroundBuilder` property to customize background of the popup menu, and `calculatePopupPosition` property to customize the position of the popup menu. For details, see the documentation and example.
