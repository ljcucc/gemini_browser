import 'dart:ui' as ui;
import 'package:gemini_browser/gemini/elements/blockquoteline_view.dart';
import 'package:gemini_browser/gemini/elements/headline_view.dart';
import 'package:gemini_browser/gemini/elements/linkline_view.dart';
import 'package:gemini_browser/gemini/elements/listlines_view.dart';
import 'package:gemini_browser/gemini/elements/paragraphline_view.dart';
import 'package:gemini_browser/gemini/elements/preformattedlines_view.dart';
import 'package:gemini_browser/gemini/elements/sitetitle_view.dart';
import 'package:gemtext/types.dart';

import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:provider/provider.dart';

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
              // width: 1000,
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
                child: LinkLineView(
                  content: item as LinkLine,
                  key: Key(item.hashCode.toString()),
                ),
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

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: elements
            .map(
              (e) => Center(
                child: Container(
                  width: 800,
                  child: e,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
