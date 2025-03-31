import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_browser/gemini/elements/image_disp/image_disp_fullscreen_page.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_connect/gemini_connection.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkImageDispWidget extends StatefulWidget {
  final Uri uri;
  final Widget child;

  const LinkImageDispWidget({
    super.key,
    required this.uri,
    required this.child,
  });

  @override
  State<LinkImageDispWidget> createState() => _LinkImageDispWidgetState();
}

class _LinkImageDispWidgetState extends State<LinkImageDispWidget> {
  bool isLoading = false;
  Uint8List? buffer;

  @override
  void initState() {
    super.initState();
  }

  _load() async {
    print("loading!!!");
    setState(() {
      isLoading = true;
    });
    final gcp = Provider.of<GeminiConnectionProvider>(context, listen: false);
    final connection = GeminiConnection();
    await connection.connect(widget.uri);
    if (connection.header?.isGemtext ?? false) {
      gcp.push(widget.uri);
    } else {
      buffer = connection.body;
    }
    setState(() {
      isLoading = false;
    });
  }

  _openImageViewer(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        // barrierDismissible: true,
        builder: (context) => ImageDisplayFullscreenPage(
          buffer: buffer!,
        ),
      ),
    );
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

    if (isLoading) {
      body = Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: LinearProgressIndicator(
          borderRadius: BorderRadius.circular(100),
        ),
      );
    }

    if (buffer != null) {
      try {
        body = Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _openImageViewer(context),
              child: Hero(
                transitionOnUserGestures: true,
                tag: buffer.hashCode,
                child: Image.memory(buffer!),
              ),
            ),
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
