import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:gemini_browser/gemini/gemtext/image_disp/link_image_disp_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:path/path.dart' as p;

abstract class GemtextLine {
  Widget build(BuildContext context);
}

class ParagraphLine extends GemtextLine {
  String source;
  ParagraphLine(this.source);

  @override
  Widget build(BuildContext context) {
    if (source.trim() == "---" || source.trim() == "===") {
      return Divider();
    }

    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Text(
        source,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}

class LinkLine extends GemtextLine {
  String source;
  late String link;
  late String text;

  LinkLine(this.source) {
    final linkContent = source.replaceFirst("=> ", "");

    link = linkContent.split(RegExp("\\s+"))[0];
    text = linkContent.substring(link.length);
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        maxLines: null,
        text.isEmpty ? link : text.trim(),
        style: TextStyle(
          decorationColor: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
    if ([".jpg", ".jpeg", ".png", ".gif", ".webp"]
        .contains(p.extension(link).toLowerCase())) {
      return LinkImageDispWidget(
        key: Key(link),
        link: link,
        child: body,
      );
    }

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        waitDuration: Duration(milliseconds: 1500),
        message: link,
        child: InkWell(
          onTap: () {
            final gcp =
                Provider.of<GeminiConnectionProvider>(context, listen: false);
            final url = gcp.connection.resolve(link);
            gcp.push(url);
          },
          child: body,
        ),
      ),
    );
  }
}

class PreformattedLines extends GemtextLine {
  String source;
  PreformattedLines(this.source);

  @override
  String toString() {
    const start = 3;
    final end = source.endsWith("```\n") ? -4 : 0;
    return source.substring(start, source.length + end);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 24),
      elevation: 3,
      shadowColor: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(16),
        child: Text(
          toString(),
          style: GoogleFonts.notoSansMono(letterSpacing: 0),
        ),
      ),
    );
  }
}

class BlockQuoteLine extends GemtextLine {
  String source;
  BlockQuoteLine(this.source);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      elevation: 8,
      shadowColor: Colors.transparent,
      surfaceTintColor: Theme.of(context).colorScheme.tertiaryContainer,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Text(source.substring(1).trimLeft()),
      ),
    );
  }
}

class ListLines extends GemtextLine {
  List<String> items;

  ListLines(this.items);

  @override
  String toString() {
    return items.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30,
                    child: Text("-"),
                  ),
                  Expanded(
                      child: Text(
                          line.length > 2 ? line.substring(1).trimLeft() : "")),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class HeadingLine extends GemtextLine {
  String source;

  /// The level number of heading line
  late int level;

  HeadingLine(this.source) {
    level = source.split(" ")[0].length;
  }

  String get text {
    return source.substring(level + 1);
  }

  @override
  Widget build(BuildContext context) {
    final style = switch (level) {
      1 => GoogleFonts.inter(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.5,
        ),
      2 => GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      3 => GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      int() => TextStyle(),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: " ".padLeft(level + 1, '#'),
              style: style.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.5),
              ),
            ),
            TextSpan(
              text: text.trim(),
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}

/// The first header will considered as a SiteTitle
class SiteTitle extends HeadingLine {
  SiteTitle(super.source);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Text(
        super.text.trim(),
        style: GoogleFonts.inter(
          fontSize: 40,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class GemtextParser {
  final Uint8List sourceBuffer;

  String title = "";
  List<GemtextLine> result = [];

  GemtextParser(this.sourceBuffer);

  List<GemtextLine> get parsed {
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
        buffer += line + "\n";
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

        buffer += line + "\n";
        continue;
      }

      if ((line.startsWith("# ") ||
              line.startsWith("## ") ||
              line.startsWith("### ")) &&
          buffer.isEmpty) {
        if (result.isEmpty)
          result.add(SiteTitle(line));
        else
          result.add(HeadingLine(line));

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
