import 'package:flutter/material.dart';
import 'package:keep_keyboard_popup_menu/keep_keyboard_popup_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KeepKeyboardPopupMenuButton'),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  flex: 0,
                  child: KeepKeyboardPopupMenuButton(
                    menuItemBuilder: (context, closePopup) => [
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        filled: true,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: KeepKeyboardPopupMenuButton(
                    menuBuilder: (context, closePopup) => Container(
                      color: Colors.teal,
                      child: InkWell(
                        onTap: closePopup,
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Text(
                            "Custom Menu Widget",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  WithKeepKeyboardPopupMenu(
                    menuItemBuilder: (context, closePopup) => [
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                    ],
                    childBuilder: (context, openPopup) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: openPopup,
                        child: Text('Custom Trigger'),
                      ),
                    ),
                  ),
                  WithKeepKeyboardPopupMenu(
                    menuItemBuilder: (context, closePopup) => [
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                    ],
                    childBuilder: (context, openPopup) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: openPopup,
                        child: Text('Custom Background'),
                      ),
                    ),
                    backgroundBuilder: (context, child) => Material(
                      elevation: 16,
                      borderRadius: BorderRadius.circular(16),
                      shadowColor: Colors.red,
                      color: Colors.grey,
                      child: child,
                    ),
                  ),
                  WithKeepKeyboardPopupMenu(
                    menuItemBuilder: (context, closePopup) => [
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                      KeepKeyboardPopupMenuItem(
                        child: Text('awa'),
                        onTap: closePopup,
                      ),
                    ],
                    childBuilder: (context, openPopup) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: openPopup,
                        child: Text('Custom position'),
                      ),
                    ),
                    calculateMenuPosition:
                        (Size menuSize, Rect overlayRect, Rect buttonRect) {
                      return Offset(8, 8);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
