import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:gemtext/types.dart';
import 'package:google_fonts/google_fonts.dart';

class PreformattedLinesView extends StatelessWidget {
  final PreformattedLines content;
  const PreformattedLinesView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MediaQuery.of(context).platformBrightness == ui.Brightness.dark
          ? ThemeData.light()
          : ThemeData.dark(),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 24),
        elevation: 3,
        shadowColor: Colors.transparent,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(16),
          child: Text(
            content.text,
            style: GoogleFonts.notoSansMono(letterSpacing: 0),
          ),
        ),
      ),
    );
  }
}
