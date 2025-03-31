import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/pages/settings.dart';

class MoreOptionMenuButton extends StatefulWidget {
  const MoreOptionMenuButton({super.key});

  @override
  State<MoreOptionMenuButton> createState() => _MoreOptionMenuButtonState();
}

class _MoreOptionMenuButtonState extends State<MoreOptionMenuButton> {
  MenuController controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.surface,
        ),
      ),
      controller: controller,
      menuChildren: [
        Container(width: 200),
        Gap(16),
        MenuItemButton(
          leadingIcon: Icon(Icons.share_outlined),
          child: Text("Share"),
          onPressed: () {},
        ),
        MenuItemButton(
          leadingIcon: Icon(Icons.refresh_outlined),
          child: Text("Refresh"),
          shortcut: SingleActivator(LogicalKeyboardKey.keyR, control: true),
          onPressed: () {
            print("yes!");
          },
        ),
        MenuItemButton(
          leadingIcon: Icon(Icons.find_in_page_outlined),
          child: Text("Find in page"),
          onPressed: () {},
        ),
        MenuItemButton(
          leadingIcon: Icon(Icons.settings_outlined),
          child: Text("Settigns"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return SettingsPage();
                },
              ),
            );
          },
        ),
        Gap(16),
      ],
      child: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
            return;
          }

          controller.open();
        },
      ),
    );
  }
}
