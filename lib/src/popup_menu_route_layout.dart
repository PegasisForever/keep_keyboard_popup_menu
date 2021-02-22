import 'package:flutter/material.dart';

const double _kMenuScreenPadding = 8.0;

// menuSize: size of the context menu, always smaller than overlayRect.size
// overlayRect: rect of the screen excluding keyboard and status bar
// buttonRect: rect of the button that triggered context menu
typedef Offset CalculateMenuPosition(
  Size menuSize,
  Rect overlayRect,
  Rect buttonRect,
);

class PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  PopupMenuRouteLayout({
    required this.buttonRect,
    required this.overlayRect,
    CalculateMenuPosition? calculateMenuPosition,
  }) : this.calculateMenuPosition =
            calculateMenuPosition ?? _defaultCalculateMenuPosition;

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final Rect buttonRect;
  final Rect overlayRect;
  final CalculateMenuPosition calculateMenuPosition;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(
      overlayRect.size -
              const Offset(_kMenuScreenPadding * 2, _kMenuScreenPadding * 2)
          as Size,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return calculateMenuPosition(childSize, overlayRect, buttonRect);
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) => true;
}

Offset _defaultCalculateMenuPosition(
    Size menuSize, Rect overlayRect, Rect buttonRect) {
  // Find the ideal vertical position.
  double y = buttonRect.top;

  // Find the ideal horizontal position.
  double x;
  if (buttonRect.left - overlayRect.left >
      overlayRect.right - buttonRect.right) {
    // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
    x = buttonRect.right - menuSize.width;
  } else {
    // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
    x = buttonRect.left;
  }

  // Avoid going outside an area defined as the rectangle 8.0 pixels from the
  // edge of the screen in every direction.
  if (x < _kMenuScreenPadding)
    x = _kMenuScreenPadding;
  else if (x + menuSize.width > overlayRect.right - _kMenuScreenPadding)
    x = overlayRect.right - menuSize.width - _kMenuScreenPadding;
  if (y < _kMenuScreenPadding)
    y = _kMenuScreenPadding;
  else if (y + menuSize.height > overlayRect.bottom - _kMenuScreenPadding)
    y = overlayRect.bottom - menuSize.height - _kMenuScreenPadding;
  return Offset(x, y);
}
