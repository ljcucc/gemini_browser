import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:gemini_browser/gemini/gemini_input_prompt_widget.dart';
import 'package:gemini_browser/gemini/gemtext/gemtext_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GeminiBrowserView extends StatelessWidget {
  const GeminiBrowserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiConnectionProvider>(
      builder: (context, gcp, child) {
        final header = gcp.connection.header;

        Widget contentView = const Center(
          child: Text("Waiting for connection"),
        );

        if (header?.status == 10) {
          contentView = const GeminiInputPropmtWidget();
        }

        if (header?.isGemtext ?? false) {
          contentView = Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              padding: EdgeInsets.all(16),
              child: GemtextView(
                sourceCode: gcp.connection.sourceCode,
              ),
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

        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              if (gcp.connecting) const LinearProgressIndicator(),
              Expanded(child: contentView),
            ],
          ),
        );
      },
    );
  }
}
