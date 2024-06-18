import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_browser/gemini/gemini_connection.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:provider/provider.dart';

class LinkImageDispWidget extends StatefulWidget {
  final String link;
  final Widget child;
  const LinkImageDispWidget(
      {super.key, required this.link, required this.child});

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
    setState(() {
      isLoading = true;
    });
    final gcp = Provider.of<GeminiConnectionProvider>(context, listen: false);
    final baseUri = gcp.connection.uri;
    final connection = GeminiConnection();
    connection.uri = baseUri;
    final url = connection.resolve(widget.link);
    await connection.connect(url);
    if (connection.header?.isGemtext ?? false) {
      gcp.push(url);
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
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: InteractiveViewer(
            child: Center(
              child: Image.memory(buffer!),
            ),
          ),
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
        message: widget.link,
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
              child: Image.memory(buffer!),
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
