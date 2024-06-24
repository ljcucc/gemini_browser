import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(children: [
        ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Icon(Icons.palette_outlined),
          title: Text("Color"),
          subtitle: Text("Custom material color theme"),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Icon(Icons.text_format_outlined),
          title: Text("Font"),
          subtitle: Text("Customize variable font"),
          onTap: () {},
        ),
      ]),
    );
  }
}
