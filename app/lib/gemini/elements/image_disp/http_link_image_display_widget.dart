import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_browser/gemini/elements/image_disp/image_disp_fullscreen_page.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_connect/gemini_connection.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HttpLinkImageDispWidget extends StatefulWidget {
  final Uri uri;
  final Widget child;

  const HttpLinkImageDispWidget({
    super.key,
    required this.uri,
    required this.child,
  });

  @override
  State<HttpLinkImageDispWidget> createState() => _LinkImageDispWidgetState();
}

class _LinkImageDispWidgetState extends State<HttpLinkImageDispWidget> {
  bool isLoaded = false;
  Uint8List? buffer;

  @override
  void initState() {
    super.initState();
  }

  _load() async {
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Material(
      color: Colors.transparent,
      child: Tooltip(
        waitDuration: Duration(milliseconds: 1500),
        message: widget.uri.toString(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: InkWell(
                onTap: _load,
                child: widget.child,
              ),
            ),
            SizedBox(width: 16),
            Icon(
              Icons.image_outlined,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ],
        ),
      ),
    );

    if (isLoaded) {
      try {
        body = Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(widget.uri.toString()),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        child: body,
      ),
    );
  }
}
