import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageDisplayFullscreenPage extends StatefulWidget {
  final Uint8List buffer;

  const ImageDisplayFullscreenPage({
    super.key,
    required this.buffer,
  });

  @override
  State<ImageDisplayFullscreenPage> createState() =>
      _ImageDisplayFullscreenPageState();
}

class _ImageDisplayFullscreenPageState
    extends State<ImageDisplayFullscreenPage> {
  @override
  Widget build(BuildContext context) {
    final body = InteractiveViewer(
      child: Center(
        child: Hero(
          tag: widget.buffer.hashCode,
          child: Image.memory(widget.buffer),
        ),
      ),
    );

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.close,
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: body),
          Positioned(top: 0, left: 0, right: 0, child: appBar),
        ],
      ),
    );
  }
}
