import 'package:flutter/material.dart';
import 'package:gemini_browser/pages/settings.dart';

class LabeledIconButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final VoidCallback onTap;
  const LabeledIconButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        foregroundColor:
            WidgetStatePropertyAll(Theme.of(context).colorScheme.onSurface),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: icon,
          ),
          Text(label),
        ],
      ),
    );
  }
}

class MoreOptionSheet extends StatelessWidget {
  const MoreOptionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(24),
        child: Wrap(
          spacing: 0,
          children: [
            LabeledIconButton(
              onTap: () {},
              icon: Icon(Icons.share_outlined),
              label: "Share",
            ),
            LabeledIconButton(
              onTap: () {},
              icon: Icon(Icons.refresh_outlined),
              label: "Refresh",
            ),
            LabeledIconButton(
              onTap: () {},
              icon: Icon(Icons.find_in_page),
              label: "Find in page",
            ),
            LabeledIconButton(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SettingsPage();
                    },
                  ),
                );
              },
              icon: Icon(Icons.settings_outlined),
              label: "Settigns",
            ),
            LabeledIconButton(
              onTap: () {},
              icon: Icon(Icons.help_outline),
              label: "Help",
            ),
          ],
        ),
      ),
    );
  }
}
