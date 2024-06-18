import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:gemini_browser/gemini/gemtext/gemtext_builder.dart';
import 'package:gemtext/parser.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';

class GemtextView extends StatelessWidget {
  final String sourceCode;
  const GemtextView({
    super.key,
    required this.sourceCode,
  });

  @override
  Widget build(BuildContext context) {
    final gcp = Provider.of<GeminiConnectionProvider>(context, listen: false);
    final header = gcp.connection.header;

    Widget statusCode() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Status code"),
          const Gap(8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Theme.of(context).colorScheme.onSurface),
            ),
            child: Center(child: Text(header?.status.toString() ?? "??")),
          ),
        ],
      );
    }

    return GemtextBuilder(
      parser: GemtextParser(gcp.connection.body),
    );

    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // statusCode(),
          Expanded(
            child: GemtextBuilder(
              parser: GemtextParser(gcp.connection.body),
            ),
          ),
        ],
      ),
    );
  }
}
