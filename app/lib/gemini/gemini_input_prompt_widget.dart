import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:provider/provider.dart';

class GeminiInputPropmtWidget extends StatefulWidget {
  const GeminiInputPropmtWidget({super.key});

  @override
  State<GeminiInputPropmtWidget> createState() =>
      _GeminiInputPropmtWidgetState();
}

class _GeminiInputPropmtWidgetState extends State<GeminiInputPropmtWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gcp.connection.header!.meta.toUpperCase(),
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 32),
            TextField(
              onSubmitted: (value) {
                final uri =
                    gcp.connection.resolve("", query: Uri.encodeFull(value));
                gcp.push(uri);
              },
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      );
    });
  }
}
