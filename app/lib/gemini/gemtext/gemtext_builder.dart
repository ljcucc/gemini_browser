import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:gemini_browser/gemini/gemtext/image_disp/link_image_disp_widget.dart';
import 'package:gemtext/parser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:path/path.dart' as p;

class GemtextBuilder extends StatelessWidget {
  final GemtextParser parser;
  const GemtextBuilder({super.key, required this.parser});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: parser.parsed.length,
      itemBuilder: (BuildContext context, int index) {
        final item = parser.parsed[index];

        switch (item.runtimeType) {
          case ParagraphLine:
            return ParagraphLineView(content: item as ParagraphLine);
          case LinkLine:
            return LinkLineView(content: item as LinkLine);
          case PreformattedLines:
            return PreformattedLinesView(content: item as PreformattedLines);
          case BlockQuoteLine:
            return BlockQuoteLineView(content: item as BlockQuoteLine);
          case ListLines:
            return ListLinesView(content: item as ListLines);
          case SiteTitle:
            return SiteTitleView(content: item as SiteTitle);
          case HeadingLine:
            return HeadingLineView(content: item as HeadingLine);
          default:
            return Container();
        }
      },
    );
  }
}

class ParagraphLineView extends StatelessWidget {
  final ParagraphLine content;

  const ParagraphLineView({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (content.source.trim() == "---" || content.source.trim() == "===") {
      return const Divider();
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Text(
        content.source,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class LinkLineView extends StatelessWidget {
  final LinkLine content;
  const LinkLineView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    Widget body = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        maxLines: null,
        content.text.isEmpty ? content.link : content.text.trim(),
        style: TextStyle(
          decorationColor: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
    if ([".jpg", ".jpeg", ".png", ".gif", ".webp"]
        .contains(p.extension(content.link).toLowerCase())) {
      return LinkImageDispWidget(
        key: Key(content.link),
        link: content.link,
        child: body,
      );
    }

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        waitDuration: const Duration(milliseconds: 1500),
        message: content.link,
        child: InkWell(
          onTap: () {
            final gcp =
                Provider.of<GeminiConnectionProvider>(context, listen: false);
            final url = gcp.connection.resolve(content.link);
            gcp.push(url);
          },
          child: body,
        ),
      ),
    );
  }
}

class PreformattedLinesView extends StatelessWidget {
  final PreformattedLines content;
  const PreformattedLinesView({super.key, required this.content});

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
          this.content.toString(),
          style: GoogleFonts.notoSansMono(letterSpacing: 0),
        ),
      ),
    );
  }
}

class BlockQuoteLineView extends StatelessWidget {
  final BlockQuoteLine content;
  const BlockQuoteLineView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 8,
      shadowColor: Colors.transparent,
      surfaceTintColor: Theme.of(context).colorScheme.tertiaryContainer,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(content.source.substring(1).trimLeft()),
      ),
    );
  }
}

class ListLinesView extends StatelessWidget {
  final ListLines content;
  const ListLinesView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in content.items)
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

class HeadingLineView extends StatelessWidget {
  final HeadingLine content;
  const HeadingLineView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final style = switch (content.level) {
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
              text: " ".padLeft(content.level + 1, '#'),
              style: style.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.5),
              ),
            ),
            TextSpan(
              text: content.text.trim(),
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}

class SiteTitleView extends StatelessWidget {
  final SiteTitle content;
  const SiteTitleView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Text(
        content.text.trim(),
        style: GoogleFonts.inter(
          fontSize: 40,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
