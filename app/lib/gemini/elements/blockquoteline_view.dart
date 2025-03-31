import 'package:flutter/material.dart';
import 'package:gemtext/types.dart';

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
