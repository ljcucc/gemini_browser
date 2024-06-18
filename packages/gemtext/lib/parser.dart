import 'dart:convert';
import 'dart:typed_data';

import 'package:gemtext/types.dart';

/// class that will convert Gemtext source code [String]
/// into a List of types like [ParagraphLine], [LinkLine]
class GemtextParser {
  final Uint8List sourceBuffer;

  String title = "";
  List result = [];

  GemtextParser(this.sourceBuffer);

  /// get parsed gemtext type [List]
  List get parsed {
    result = [];
    _parse(utf8.decode(sourceBuffer));
    return result;
  }

  void _parse(String sourceCode) {
    String buffer = "";

    for (final line in sourceCode.split("\n")) {
      // print(line);

      final isListGroup = buffer.startsWith("* ");
      final isPreformatted = buffer.startsWith("```");

      if (line.startsWith("* ") && (isListGroup || buffer.isEmpty)) {
        // print("list detected");
        buffer += "$line\n";
        continue;
      } else if (isListGroup && !line.startsWith("* ")) {
        result.add(
          ListLines(buffer.trim().split("\n")),
        );
        buffer = "";
      }

      // start and reset of code block
      if (line.startsWith("```")) {
        // print("preformat heading detected");
        buffer += "```\n";

        if (isPreformatted) {
          result.add(PreformattedLines(buffer));
          buffer = "";
        }
        continue;
      } else if (isPreformatted) {
        // end of codeblock

        buffer += "$line\n";
        continue;
      }

      if ((line.startsWith("# ") ||
              line.startsWith("## ") ||
              line.startsWith("### ")) &&
          buffer.isEmpty) {
        if (result.isEmpty) {
          result.add(SiteTitle(line));
        } else {
          result.add(HeadingLine(line));
        }

        continue;
      }

      if (line.startsWith("=> ") && buffer.isEmpty) {
        result.add(LinkLine(line));
        continue;
      }

      if (line.startsWith(">") && buffer.isEmpty) {
        result.add(BlockQuoteLine(line));
        continue;
      }

      result.add(ParagraphLine(line));
    }
  }
}
