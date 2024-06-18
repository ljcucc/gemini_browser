import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:gemini_browser/gemini/gemtext/gemtext_parser.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';

class GemtextDispWidget extends StatelessWidget {
  final String sourceCode;
  const GemtextDispWidget({
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
          Text("Status code"),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.all(4),
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

    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          statusCode(),
          for (final line in GemtextParser(gcp.connection.body).parsed)
            line.build(context),
        ],
      ),
    );
  }
}
