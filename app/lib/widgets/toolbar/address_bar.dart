import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_browser/widgets/toolbar/status_code.dart';
import 'package:provider/provider.dart';

class AddressBar extends StatefulWidget {
  const AddressBar({super.key});

  @override
  State<AddressBar> createState() => _AddressBarState();
}

class _AddressBarState extends State<AddressBar> {
  final controller = SearchController();
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      controller.text = gcp.connection.uri.toString();

      return SearchAnchor(
        searchController: controller,
        // isFullScreen: false,
        viewLeading: IconButton(
          icon: Icon(Icons.close_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        viewTrailing: [
          IconButton(
            icon: Icon(Icons.arrow_forward_outlined),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        viewOnChanged: (text) {
          if (text.length > 3) return;
          if (controller.isOpen) controller.closeView(text);
        },
        builder: (context, controller) {
          return SearchBar(
            controller: controller,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StatusCodeWidget(
                code: '20',
              ),
            ),
            hintText: "Type a capsule url or search",
            hintStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.35),
              ),
            ),
            trailing: [
              if (isTyping)
                IconButton.filledTonal(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {},
                ),
            ],
            // backgroundColor:
            //     WidgetStatePropertyAll(Theme.of(context).colorScheme.surface),
            // elevation: WidgetStatePropertyAll(0),
            shadowColor: WidgetStatePropertyAll(Colors.transparent),
            onChanged: (text) {
              // if (text.length > 4) {
              //   controller.openView();
              //   return;
              // }
              if (!controller.isOpen) return;

              controller.closeView("");
            },
            onSubmitted: (text) {
              final gcp =
                  Provider.of<GeminiConnectionProvider>(context, listen: false);
              if (Uri.tryParse(text)?.scheme.isEmpty ?? true) {
                text = "gemini://$text";
              }
              gcp.push(Uri.tryParse(text) ?? gcp.connection.uri);
            },
            onTap: () {
              setState(() {
                isTyping = true;
              });
            },
            onTapOutside: (e) {
              setState(() {
                isTyping = false;
              });
            },
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) async {
          return [
            ListTile(
              title: Text("title"),
            ),
          ];
        },
      );
    });
  }
}
