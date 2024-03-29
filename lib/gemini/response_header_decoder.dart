class ResponseHeaderDecoder {
  /// The source code that decoder decoded from
  final String line;

  /// Two-digit numeric status code, decoded from line.
  /// If the status code cannot be parsed, number will be -1.
  late final int status;

  /// META is a string whose meaning is status dependent.
  late final String meta;

  late final String mime;

  ResponseHeaderDecoder(this.line) {
    status = int.tryParse(line.substring(0, 2)) ?? -1;
    meta = line.substring(3);

    if (meta.length > 1024) {
      throw "Meta length reached the limit of 1024 bytes: $meta";
    }

    mime = "";
  }

  /// If the connect need to render as a gemtext, the return will be true.
  bool get isGemtext => status == 20 && meta.startsWith("text/gemini");

  bool get isPlainText => status == 20 && meta.startsWith("text/plain");

  @override
  String toString() {
    return "line: $line\nstatus: $status, meta: $meta, mime: $mime";
  }
}
