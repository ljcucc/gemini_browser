import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gemini_browser/providers/split_view_controller.dart';
import 'package:gemini_browser/providers/split_view_list_controller.dart';
import 'package:provider/provider.dart';

class TopbarMenuButton extends StatefulWidget {
  const TopbarMenuButton({super.key});

  @override
  State<TopbarMenuButton> createState() => _TopbarMenuButtonState();
}

class _TopbarMenuButtonState extends State<TopbarMenuButton> {
  final MenuController _menuController = MenuController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listController = Provider.of<SplitViewListController>(context);
    final controller = Provider.of<SplitViewController>(context);

    final isMobile = Platform.isAndroid || Platform.isIOS;

    /// the screen width is smaller than compact that defined in material you guideline
    final isCompact = MediaQuery.of(context).size.width < 600;

    Widget menuButton({
      required onPressed,
      required child,
      Widget? leadingIcon,
      MenuSerializableShortcut? shortcut,
    }) {
      if (isMobile) {
        return MenuItemButton(
          onPressed: onPressed,
          leadingIcon: leadingIcon,
          child: child,
        );
      }

      return MenuItemButton(
        onPressed: onPressed,
        shortcut: shortcut,
        leadingIcon: leadingIcon,
        child: child,
      );
    }

    final style = MenuStyle(
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 16,
      )),
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
      backgroundColor:
          MaterialStatePropertyAll(Theme.of(context).colorScheme.surface),
      alignment: Alignment.bottomLeft,
    );

    final child = IconButton(
      onPressed: () {
        if (_menuController.isOpen) {
          _menuController.close();
          return;
        }

        _menuController.open();
      },
      icon: Icon(Icons.more_vert),
    );

    final multiwindowItems = [
      if (listController.splitedView.length > 1)
        menuButton(
          onPressed: () {
            listController.close(controller);
          },
          shortcut: SingleActivator(LogicalKeyboardKey.keyW, meta: true),
          leadingIcon: Icon(Icons.close),
          child: Text("Close Window"),
        ),
      menuButton(
        onPressed: () {
          listController.newSplit();
        },
        shortcut: SingleActivator(LogicalKeyboardKey.keyN, meta: true),
        leadingIcon: RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.splitscreen),
        ),
        child: Text("New window"),
      ),
      const Divider(),
    ];

    final children = [
      const SizedBox(width: 200),
      if (!isCompact) ...multiwindowItems,
      menuButton(
        onPressed: () {},
        shortcut: SingleActivator(LogicalKeyboardKey.keyF, meta: true),
        leadingIcon: Icon(Icons.find_in_page),
        child: Text("Find in page"),
      ),
      menuButton(
        onPressed: () {},
        shortcut:
            SingleActivator(LogicalKeyboardKey.keyI, meta: true, shift: true),
        leadingIcon: Icon(Icons.code),
        child: Text("Inspector"),
      ),
      const Divider(),
      menuButton(
        onPressed: () {},
        shortcut: SingleActivator(LogicalKeyboardKey.keyY, meta: true),
        leadingIcon: Icon(Icons.history_rounded),
        child: Text("History"),
      ),
      menuButton(
        onPressed: () {},
        shortcut: SingleActivator(LogicalKeyboardKey.comma, meta: true),
        leadingIcon: Icon(Icons.settings_outlined),
        child: Text("Settings"),
      ),
    ];

    return MenuAnchor(
      style: style,
      controller: _menuController,
      menuChildren: children,
      child: child,
      alignmentOffset: Offset(-160, 0),
    );
  }
}
