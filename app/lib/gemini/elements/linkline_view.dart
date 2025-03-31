import 'dart:math';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/elements/image_disp/http_link_image_display_widget.dart';
import 'package:gemini_browser/gemini/elements/image_disp/link_image_disp_widget.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_connect/url_resolve.dart';
import 'package:gemtext/types.dart';
import 'package:provider/provider.dart';

bool isImageLink(Uri? uri) {
  return (uri?.path.endsWith("jpeg") ?? false) ||
      (uri?.path.endsWith("jpg") ?? false) ||
      (uri?.path.endsWith("png") ?? false) ||
      (uri?.path.endsWith("webp") ?? false);
}

class LinkLineViewOutlineBroder extends RoundedRectangleBorder
    implements WidgetStateOutlinedBorder {
  @override
  OutlinedBorder? resolve(Set<WidgetState> states) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
  }
}

class LinkLineView extends StatefulWidget {
  final LinkLine content;
  const LinkLineView({super.key, required this.content});

  @override
  State<LinkLineView> createState() => _LinkLineViewState();
}

class _LinkLineViewState extends State<LinkLineView> {
  Uri? uri;

  @override
  initState() {
    super.initState();
    uri = Uri.tryParse(widget.content.link);
  }

  onClick() {
    final gcp = Provider.of<GeminiConnectionProvider>(context, listen: false);
    print("navigate to :$uri");

    if (uri == null) return;
    if (isImageLink(uri)) return;

    gcp.push(uri!);
  }

  @override
  Widget build(BuildContext context) {
    Widget linkText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.content.text.trim().isEmpty)
          Text(
            maxLines: null,
            widget.content.link,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  // decoration: TextDecoration.underline,
                  // decorationThickness: 1.5,
                  // decorationStyle: TextDecorationStyle.dashed,
                  // fontFamilyFallback: ["NotoEmoji"],
                ),
          ),
        if (widget.content.text.trim().isNotEmpty) ...[
          Container(
            // decoration: BoxDecoration(
            //   border: Border(
            //     bottom: BorderSide(style: BorderStyle()),
            //   ),
            // ),
            child: Text(
              maxLines: null,
              widget.content.text.trim(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    // decoration: TextDecoration.underline,
                    // decorationThickness: 1.5,
                    // decorationStyle: TextDecorationStyle.dashed,
                    // fontFamilyFallback: ["RobotoFlex", "NotoEmoji"],
                  ),
            ),
          ),
          Opacity(
            opacity: .5,
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              widget.content.link,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );

    final body = Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      if (uri?.scheme.isEmpty ?? true) {
        final pathTo = navigateToPath(
          gcp.connection.uri.path,
          uri?.path ?? "",
        );
        uri = uriOverride(
          gcp.connection.uri,
          Uri(
            query: uri?.query ?? " ",
            path: pathTo,
          ),
          forceOverrideQuery: true,
        );
      }
      final labelText = TextButton(
        onPressed: null,
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            // EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            EdgeInsets.zero,
          ),
          shape: LinkLineViewOutlineBroder(),
        ),
        child: linkText,
      );

      if (isImageLink(uri) && uri!.scheme.startsWith("http")) {
        return HttpLinkImageDispWidget(
          uri: uri!,
          child: labelText,
        );
      }
      if (isImageLink(uri) && uri!.scheme.startsWith("gemini")) {
        return LinkImageDispWidget(
          uri: uri!,
          child: labelText,
        );
      }

      return Material(
        child: InkWell(
          onTap: () {
            onClick();
          },
          // style: ButtonStyle(
          //   alignment: Alignment.center,
          //   padding: const WidgetStatePropertyAll(
          //     // EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          //     EdgeInsets.zero,
          //   ),
          //   shape: LinkLineViewOutlineBroder(),
          // ),
          child: linkText,
        ),
      );
    });

    return Tooltip(
      waitDuration: const Duration(milliseconds: 1500),
      message: widget.content.link,
      child: body,
    );
  }
}
