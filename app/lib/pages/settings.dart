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
          // contentPadding: EdgeInsets.all(8),
          leading: Icon(Icons.palette_outlined),
          title: Text("Color"),
          subtitle: Text("Custom material color theme"),
          onTap: () {},
        ),
        ListTile(
          // contentPadding: EdgeInsets.all(8),
          leading: Icon(Icons.text_format_outlined),
          title: Text("Font"),
          subtitle: Text("Customize variable font"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("License"),
          subtitle: Text("List of used libraries and open source license"),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const LicensePage(
                    applicationVersion: "1.0.0",
                    applicationLegalese: "Made with love from the_ITWolf",
                  );
                },
              ),
            );
          },
        ),
      ]),
    );
  }
}
