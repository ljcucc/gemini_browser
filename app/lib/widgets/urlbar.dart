import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:provider/provider.dart';

class UrlBarWidget extends StatefulWidget {
  const UrlBarWidget({super.key});

  @override
  State<UrlBarWidget> createState() => _UrlBarWidgetState();
}

class _UrlBarWidgetState extends State<UrlBarWidget> {
  TextEditingController _urlInput = TextEditingController(text: "");

  _sendGeminiRequest() async {
    print("openning request");
    final gcp = Provider.of<GeminiConnectionProvider>(context, listen: false);
    final connection = gcp.connection;
    final text = _urlInput.text;
    var url = (text.contains(" ") || !text.contains("."))
        ? connection.searchResolve(text)
        : connection.resolve(text);

    await gcp.stream(url);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _urlInput.text = "gemini://geminispace.info/search?uxn";
    });
  }

  @override
  Widget build(BuildContext context) {
    final textfield =
        Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      _urlInput.text = gcp.connection.uri.toString();
      return TextField(
        controller: _urlInput,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          hintText: "Type URL here...",
        ),
        onSubmitted: (_) => _sendGeminiRequest(),
      );
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: textfield,
    );
  }
}
