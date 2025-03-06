import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/fonts.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_connect/url_resolve.dart';
import 'package:provider/provider.dart';

class PromptTextfield extends StatefulWidget {
  final VoidCallback onClose;
  const PromptTextfield({super.key, required this.onClose});

  @override
  State<PromptTextfield> createState() => _PromptTextfieldState();
}

class _PromptTextfieldState extends State<PromptTextfield> {
  TextEditingController _controller = TextEditingController();

  onSend() async {
    final gcp = Provider.of<GeminiConnectionProvider>(context, listen: false);
    final uri = uriOverride(
      Uri(query: Uri.encodeFull(_controller.text)),
      gcp.connection.prompt?.destination ?? Uri(),
    );
    await gcp.push(uri);
    _controller.clear();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => onSend(),
              scrollPadding: EdgeInsets.all(8),
              decoration: InputDecoration(border: InputBorder.none),
              maxLines: 10,
              minLines: 1,
            ),
          ),
          Gap(8),
          IconButton.filledTonal(
            icon: Icon(Icons.arrow_forward),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}

class PromptSheet extends StatelessWidget {
  const PromptSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      return SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                gcp.connection.prompt?.title ?? "Title not found",
                style: TextStyle(
                  fontFamily: "RobotoFlex",
                  fontSize: 24,
                  fontVariations: fontVariations,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                gcp.connection.prompt?.destination.toString() ??
                    "destination not found",
              ),
              Gap(16),
              PromptTextfield(
                onClose: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
