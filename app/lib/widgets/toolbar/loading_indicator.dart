import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:provider/provider.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      return LinearProgressIndicator(
        value: gcp.connecting ? null : 0,
        minHeight: gcp.connecting ? null : 2,
      );
    });
  }
}
