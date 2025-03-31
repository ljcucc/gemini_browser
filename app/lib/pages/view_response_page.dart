import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:provider/provider.dart';

class ViewResponsePage extends StatelessWidget {
  const ViewResponsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      final conn = gcp.history.last;
      return Scaffold(
        appBar: AppBar(title: Text("Response")),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: (conn.header?.isGemtext ?? false) ||
                  (conn.header?.isPlainText ?? false)
              ? SelectionArea(child: Text(conn.sourceCode))
              : Text("Response cannot be preview"),
        ),
      );
    });
  }
}
