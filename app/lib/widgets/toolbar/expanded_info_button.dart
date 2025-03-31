import 'package:flutter/material.dart';
import 'package:gemini_browser/widgets/toolbar/site_info.dart';

class ExpandedInfoButton extends StatefulWidget {
  const ExpandedInfoButton({super.key});

  @override
  State<ExpandedInfoButton> createState() => _ExpandedInfoButtonState();
}

class _ExpandedInfoButtonState extends State<ExpandedInfoButton> {
  MenuController controller = MenuController();
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: controller,
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.surface,
        ),
      ),
      child: IconButton(
        icon: Icon(Icons.info_outline),
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
            return;
          }
          controller.open();
        },
      ),
      menuChildren: [
        Container(
          width: 400,
          padding: const EdgeInsets.all(48.0),
          child: SiteInfoWidget(),
        ),
      ],
    );
  }
}
