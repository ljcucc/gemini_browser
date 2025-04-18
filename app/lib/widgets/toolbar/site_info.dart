import 'package:custom_waveline/custom_waveline.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/pages/main_browser/compact.dart';
import 'package:gemini_browser/pages/view_response_page.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_browser/widgets/toolbar/more_option/more_option_sheet.dart';
import 'package:provider/provider.dart';

class SiteInfoWidget extends StatelessWidget {
  const SiteInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      final rowActions = Wrap(
        alignment: WrapAlignment.start,
        children: [
          LabeledIconButton(
            icon: Icon(Icons.file_download_outlined),
            label: "View Response",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<GeminiConnectionProvider>.value(
                  value: gcp,
                  child: ViewResponsePage(),
                ),
              ));
            },
          ),
          LabeledIconButton(
            icon: Icon(Icons.file_upload_outlined),
            label: "View Request",
            onTap: () {},
          ),
        ],
      );
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(minWidth: 500),
            child: Column(children: [
              Text(
                gcp.connection.uri.host,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                gcp.connection.uri.toString(),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            // padding: const EdgeInsets.all(24),
            child: CustomPaint(
              size: Size.fromHeight(60),
              painter: CustomWaveline(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.35),
                strokeWidth: 2,
                curveWidth: 28,
                curveHeight: 4,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // padding: EdgeInsets.all(24),
            child: rowActions,
          ),
          // Gap(24),
        ],
      );
    });
  }
}
