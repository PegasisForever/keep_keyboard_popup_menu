import './with_keep_keyboard_popup_menu.dart';
import 'package:flutter/material.dart';

class KeepKeyboardPopupMenuButton extends StatefulWidget {
  final Widget? child;
  final Widget? icon;
  final bool enabled;
  final MenuBuilder? menuBuilder;
  final MenuItemBuilder? menuItemBuilder;
  final String? tooltip;
  final EdgeInsetsGeometry padding;
  final double? iconSize;

  const KeepKeyboardPopupMenuButton({
    Key? key,
    this.icon,
    this.enabled = true,
    this.menuBuilder,
    this.menuItemBuilder,
    this.tooltip,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.iconSize,
  })  : assert(!(child != null && icon != null),
            'You can only pass [child] or [icon], not both.'),
        assert((menuBuilder == null) != (menuItemBuilder == null),
            'You can only pass one of [menuBuilder] and [menuItemBuilder].'),
        super(key: key);

  @override
  _KeepKeyboardPopupMenuButtonState createState() =>
      _KeepKeyboardPopupMenuButtonState();
}

class _KeepKeyboardPopupMenuButtonState
    extends State<KeepKeyboardPopupMenuButton> {
  final _popupMenuKey = GlobalKey<WithKeepKeyboardPopupMenuState>();

  void _showMenu() => _popupMenuKey.currentState!.openPopupMenu();

  @override
  Widget build(BuildContext context) {
    late final Widget child;
    if (widget.child != null) {
      child = Tooltip(
        message:
            widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
        child: InkWell(
          onTap: widget.enabled ? _showMenu : null,
          child: widget.child,
        ),
      );
    } else {
      child = IconButton(
        icon: widget.icon ?? Icon(Icons.adaptive.more),
        padding: widget.padding,
        iconSize: widget.iconSize ?? 24.0,
        tooltip:
            widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
        onPressed: widget.enabled ? _showMenu : null,
      );
    }

    return WithKeepKeyboardPopupMenu(
      key: _popupMenuKey,
      menuBuilder: widget.menuBuilder,
      menuItemBuilder: widget.menuItemBuilder,
      child: child,
    );
  }
}
