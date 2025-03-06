import 'dart:math';
import 'dart:ui' as ui;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:gemini_browser/gemini/gemtext/linkline_view.dart';
import 'package:gemini_browser/widgets/waveline_divider.dart';
import 'package:gemtext/types.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemtext/parser.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';

class GemtextView extends StatelessWidget {
  const GemtextView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      return GemtextBuilder(
        parsed: gcp.connection.parsed,
      );
    });
  }
}

const fontVariations = <ui.FontVariation>[
  // RobotoFlex-VariableFont_GRAD,XOPQ,XTRA,YOPQ,YTAS,YTDE,YTFI,YTLC,YTUC,opsz,slnt,wdth,wght
  ui.FontVariation('wght', 800.0),
  ui.FontVariation('wdth', 151.0),
  ui.FontVariation('opsz', 24.0),
  ui.FontVariation('GRAD', 0.0),
  ui.FontVariation('XOPQ', 96.0),
  ui.FontVariation('XTRA', 603.0),
  ui.FontVariation('YOPQ', 79.0),
  ui.FontVariation('YTAS', 750.0),
  ui.FontVariation('YTDE', -203.0),
  ui.FontVariation('YTFI', 738.0),
  ui.FontVariation('YTLC', 514.0),
  ui.FontVariation('YTUC', 712.0),
];

class GemtextBuilder extends StatelessWidget {
  final List parsed;
  const GemtextBuilder({super.key, required this.parsed});

  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = parsed.map<Widget>(
      (item) {
        switch (item.runtimeType) {
          case ParagraphLine:
            return SizedBox(
              width: 1000,
              child: ParagraphLineView(content: item as ParagraphLine),
            );
          case LinkLine:
            // return LinkLineView(content: item as LinkLine);
            return Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 500,
                ),
                child: LinkLineView(content: item as LinkLine),
              ),
            );
          case PreformattedLines:
            return SizedBox(
              width: 1000,
              child: Align(
                alignment: Alignment.topLeft,
                child:
                    PreformattedLinesView(content: item as PreformattedLines),
              ),
            );
          case BlockQuoteLine:
            return SizedBox(
              width: 1000,
              child: BlockQuoteLineView(content: item as BlockQuoteLine),
            );
          case ListLines:
            return SizedBox(
              width: 1000,
              child: ListLinesView(content: item as ListLines),
            );
          case SiteTitle:
            return SizedBox(
              width: 1000,
              child: SiteTitleView(content: item as SiteTitle),
            );
          case HeadingLine:
            return SizedBox(
              width: 1000,
              child: HeadingLineView(content: item as HeadingLine),
            );
          default:
            return Container();
        }
      },
    ).toList();

    // return SingleChildScrollView(
    //   scrollDirection: Axis.vertical,
    //   padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
    //   child: Wrap(
    //     spacing: 8,
    //     runSpacing: 8,
    //     children: elements,
    //   ),
    // );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      scrollDirection: Axis.vertical,
      itemCount: elements.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsetsDirectional.only(bottom: 8),
          child: elements[index],
        );
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
    if (content.source.trim().startsWith("--") ||
        content.source.trim().startsWith("==")) {
      return const WavelineDivider();
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      // padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        content.source,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class PreformattedLinesView extends StatelessWidget {
  final PreformattedLines content;
  const PreformattedLinesView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MediaQuery.of(context).platformBrightness == ui.Brightness.dark
          ? ThemeData.light()
          : ThemeData.dark(),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 24),
        elevation: 3,
        shadowColor: Colors.transparent,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(16),
          child: Text(
            content.text,
            style: GoogleFonts.notoSansMono(letterSpacing: 0),
          ),
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
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
      1 => TextStyle(
          fontFamily: "RobotoFlex",
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.5,
          fontVariations: fontVariations,
        ),
      2 => TextStyle(
          fontFamily: "RobotoFlex",
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontVariations: fontVariations,
        ),
      3 => TextStyle(
          fontFamily: "RobotoFlex",
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontVariations: fontVariations,
        ),
      int() => TextStyle(),
    };

    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 32),
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
        style: TextStyle(
          fontFamily: "RobotoFlex",
          fontSize: 40,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
          fontVariations: fontVariations,
        ),
      ),
    );
  }
}
