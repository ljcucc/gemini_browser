import 'package:flutter/material.dart';
import 'package:gemini_browser/widgets/toolbar/site_info.dart';

class InfoSheet extends StatelessWidget {
  const InfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SiteInfoWidget(),
      minimum: EdgeInsets.only(bottom: 48),
    );
  }
}
