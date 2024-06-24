import 'package:flutter/material.dart';
import 'package:gemini_browser/widgets/prompt/prompt_sheet.dart';
import 'package:provider/provider.dart';

/// A [FloatingActionButton] that will showing on bottom corner of the screen
/// When a prompt is avaliable to reply.
class PromptFab extends StatefulWidget {
  const PromptFab({super.key});

  @override
  State<PromptFab> createState() => _PromptFabState();
}

class _PromptFabState extends State<PromptFab> {
  PersistentBottomSheetController? controller;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.question_answer_outlined),
      onPressed: () async {
        // final pc = Provider.of<PromptController>(context, listen: false);
        print("showing promtp sheet");
        if (controller != null) {
          controller?.close();
          return;
        }
        controller = showBottomSheet(
          enableDrag: true,
          showDragHandle: true,
          context: context,
          builder: (BuildContext context) {
            return const PromptSheet();
          },
        );
        await controller?.closed;
        controller = null;
      },
    );
  }
}
