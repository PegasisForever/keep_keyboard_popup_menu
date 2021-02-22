import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'animated_popup_menu.dart';
import 'keep_keyboard_popup_menu_item.dart';
import 'popup_menu_route_layout.dart';

const double _kMenuWidthStep = 56.0;
const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;

const double _kMenuVerticalPadding = 8.0;

typedef List<KeepKeyboardPopupMenuItem> MenuItemBuilder(
  BuildContext context,
  ClosePopupFn closePopup,
);
typedef Widget MenuBuilder(
  BuildContext context,
  ClosePopupFn closePopup,
);
typedef Future<void> ClosePopupFn();

enum PopupMenuState {
  CLOSED,
  OPENING,
  OPENED,
  CLOSING,
}

class WithKeepKeyboardPopupMenu extends StatefulWidget {
  final Widget child;
  final MenuBuilder? menuBuilder;
  final MenuItemBuilder? menuItemBuilder;
  final CalculateMenuPosition? calculateMenuPosition;
  final PopupMenuBackgroundBuilder? backgroundBuilder;

  WithKeepKeyboardPopupMenu({
    required this.child,
    this.menuBuilder,
    this.menuItemBuilder,
    this.calculateMenuPosition,
    this.backgroundBuilder,
    Key? key,
  })  : assert((menuBuilder == null) != (menuItemBuilder == null),
            'You can only pass one of [menuBuilder] and [menuItemBuilder].'),
        super(key: key);

  @override
  WithKeepKeyboardPopupMenuState createState() =>
      WithKeepKeyboardPopupMenuState();
}

class WithKeepKeyboardPopupMenuState extends State<WithKeepKeyboardPopupMenu> {
  final GlobalKey _childKey = GlobalKey();
  GlobalKey<AnimatedPopupMenuState> _menuKey = GlobalKey();
  OverlayEntry? _entry;
  PopupMenuState menuState = PopupMenuState.CLOSED;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (menuState == PopupMenuState.OPENED ||
            menuState == PopupMenuState.OPENING) {
          closePopupMenu();
          return false;
        } else {
          return true;
        }
      },
      child: Container(
        key: _childKey,
        child: widget.child,
      ),
    );
  }

  Rect _getChildRect() {
    final childRenderBox =
        _childKey.currentContext!.findRenderObject() as RenderBox;
    final childSize = childRenderBox.size;
    final childPos = childRenderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
      childPos.dx,
      childPos.dy,
      childSize.width,
      childSize.height,
    );
  }

  Rect _getOverlayRect(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding.copyWith(
      bottom: max(mediaQuery.viewInsets.bottom, mediaQuery.padding.bottom),
    );

    return Rect.fromLTWH(
      padding.left,
      padding.top,
      mediaQuery.size.width - padding.horizontal,
      mediaQuery.size.height - padding.vertical,
    );
  }

  Widget _buildPopupBody() {
    if (widget.menuBuilder != null) {
      return widget.menuBuilder!(context, closePopupMenu);
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: _kMenuVerticalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.menuItemBuilder!(context, closePopupMenu),
        ),
      );
    }
  }

  Future<void> openPopupMenu() async {
    if (menuState == PopupMenuState.CLOSED) {
      menuState = PopupMenuState.OPENING;

      final openMenuCompleter = Completer<void>();

      _entry = OverlayEntry(builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: closePopupMenu,
              ),
            ),
            CustomSingleChildLayout(
              delegate: PopupMenuRouteLayout(
                buttonRect: _getChildRect(),
                overlayRect: _getOverlayRect(context),
                calculateMenuPosition: widget.calculateMenuPosition,
              ),
              child: AnimatedPopupMenu(
                key: _menuKey,
                backgroundBuilder: widget.backgroundBuilder,
                onFullyOpened: () {
                  openMenuCompleter.complete();
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: _kMenuMinWidth,
                    maxWidth: _kMenuMaxWidth,
                  ),
                  child: SingleChildScrollView(
                    child: IntrinsicWidth(
                      stepWidth: _kMenuWidthStep,
                      child: _buildPopupBody(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      });

      final overlay = Overlay.of(context)!;
      overlay.insert(_entry!);

      await openMenuCompleter.future;
      menuState = PopupMenuState.OPENED;
    }
  }

  Future<void> closePopupMenu() async {
    if (menuState == PopupMenuState.OPENED ||
        menuState == PopupMenuState.OPENING) {
      menuState = PopupMenuState.CLOSING;
      await _menuKey.currentState!.hideMenu();
      _entry!.remove();
      menuState = PopupMenuState.CLOSED;
    }
  }
}
