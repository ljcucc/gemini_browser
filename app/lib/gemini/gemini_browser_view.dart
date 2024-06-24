import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemtext_view.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GeminiBrowserView extends StatelessWidget {
  const GeminiBrowserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiConnectionProvider>(
      builder: (context, gcp, child) {
        print("browser update");
        final header = gcp.connection.header;

        Widget contentView = const Center(
          child: Text("Waiting for connection"),
        );

        // if (header?.status == 10) {
        // }

        if (header?.isGemtext ?? false) {
          contentView = Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              // padding: EdgeInsets.all(16),
              child: const GemtextView(),
            ),
          );
        }

        if (header?.isPlainText ?? false) {
          contentView = InteractiveViewer(
            child: SelectionArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    gcp.connection.sourceCode,
                    style: GoogleFonts.robotoMono(),
                  ),
                ),
              ),
            ),
          );
        }

        if (header?.meta.startsWith("image/") ?? false) {
          contentView = InteractiveViewer(
            child: Center(
              child: Image.memory(
                gcp.connection.body,
              ),
            ),
          );
        }

        return SelectionArea(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Expanded(child: contentView),
              ],
            ),
          ),
        );
      },
    );
  }
}
