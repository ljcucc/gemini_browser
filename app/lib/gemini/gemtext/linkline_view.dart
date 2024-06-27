import 'dart:math';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_connect/url_resolve.dart';
import 'package:gemtext/types.dart';
import 'package:provider/provider.dart';

class LinkLineViewOutlineBroder extends RoundedRectangleBorder
    implements WidgetStateOutlinedBorder {
  @override
  OutlinedBorder? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      );
    }
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
  }
}

class LinkLineView extends StatelessWidget {
  final LinkLine content;
  const LinkLineView({super.key, required this.content});

  onClick(GeminiConnectionProvider gcp) {
    if (Uri.tryParse(content.link)?.scheme.isNotEmpty ?? false) {
      gcp.push(Uri.tryParse(content.link)!);
      return;
    }
    final pathTo = navigateToPath(
      gcp.connection.uri.path,
      Uri.tryParse(content.link)?.path ?? "",
    );
    final uri = uriOverride(
      gcp.connection.uri,
      Uri(
        query: Uri.tryParse(content.link)?.query ?? " ",
        path: pathTo,
      ),
      forceOverrideQuery: true,
    );
    print("navigate to :$uri");
    gcp.push(uri);
  }

  @override
  Widget build(BuildContext context) {
    Widget linkText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.text.trim().isEmpty)
          Text(
            maxLines: null,
            content.link,
          ),
        if (content.text.trim().isNotEmpty) ...[
          Text(
            maxLines: null,
            content.text.trim(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Opacity(
            opacity: .5,
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              content.link,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );

    final body = Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      final random = Random(content.text.trim().hashCode);
      final randomColor = Color.fromARGB(
        random.nextInt(255),
        random.nextInt(255),
        random.nextInt(255),
        255,
      );
      return FilledButton.tonal(
        onPressed: () {
          onClick(gcp);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Theme.of(context)
                  .colorScheme
                  .surfaceContainerHigh
                  .harmonizeWith(randomColor)
              // .withOpacity(0.5),
              ),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
          shape: LinkLineViewOutlineBroder(),
        ),
        child: linkText,
      );
    });

    return Tooltip(
      waitDuration: const Duration(milliseconds: 1500),
      message: content.link,
      child: body,
    );
  }
}
