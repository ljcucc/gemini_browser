/// A Paragraph of gemtext, contains one string souce.
class ParagraphLine {
  String source;
  ParagraphLine(this.source);
}

/// A Link of gemtext, contains a [String] link and a display text [String]
class LinkLine {
  String source;
  late String link;
  late String text;

  LinkLine(this.source) {
    final linkContent = source.replaceFirst("=>", "").trimLeft();

    link = linkContent.split(RegExp("\\s+"))[0];
    text = linkContent.substring(link.length);
  }
}

/// A Preformatted block of gemtext
class PreformattedLines {
  String source;
  PreformattedLines(this.source);

  get text {
    const start = 3;
    final end = source.endsWith("```\n") ? -4 : 0;
    return source.substring(start, source.length + end);
  }
}

/// A block quote of gemtext
class BlockQuoteLine {
  String source;
  BlockQuoteLine(this.source);

  get text => source.substring(1).trimLeft();
}

/// A list of gemtext
class ListLines {
  List<String> items;

  ListLines(this.items);

  @override
  String toString() {
    return items.toString();
  }
}

/// A Heading of gemtext
class HeadingLine {
  String source;

  /// The level number of heading line
  late int level;

  HeadingLine(this.source) {
    if (source.startsWith("###")) {
      level = 3;
    } else if (source.startsWith("##")) {
      level = 2;
    } else if (source.startsWith("#")) {
      level = 1;
    } else {
      level = 0;
    }
  }

  String get text {
    return source.substring(level).trimLeft();
  }
}

/// The first header will considered as a SiteTitle
class SiteTitle extends HeadingLine {
  SiteTitle(super.source);

  @override
  get text => super.text.trim();
}
