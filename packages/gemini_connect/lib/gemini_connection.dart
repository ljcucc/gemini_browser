import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:gemini_connect/response_header_decoder.dart';
import 'package:path/path.dart' as p;

class GeminiConnection {
  // resolve non-gemini connection
  final Function(Uri url) resolver;
  GeminiConnection({required this.resolver});

  /// The url that this connection provider stored
  Uri uri = Uri();

  Uint8List? _buffer;

  /// get the buffer, otherwise return 0 length list
  Uint8List get buffer => _buffer ?? Uint8List(0);

  /// The ending position of a header in buffer
  int headerEnd = -1;

  /// The source code of gemtext to be display
  String get sourceCode {
    return utf8.decode(body);
  }

  Uint8List get body => Uint8List.sublistView(buffer, headerEnd + 1);

  /// The response header will provided (and reset) after a connection is made
  ///
  /// If a connection failed, the response header will be cleared
  ResponseHeaderDecoder? header;

  String defaultSearch = "gemini://kennedy.gemi.dev/search?";

  Uri searchResolve(String query) {
    return Uri.parse("$defaultSearch${Uri.encodeFull(query)}");
  }

  Uri resolve(String linkText, {String query = ""}) {
    var protocol = Uri.tryParse(linkText)?.scheme ?? "";
    if (protocol.isNotEmpty && protocol != "gemini") {
      return Uri.parse(linkText);
    }

    if (query.isNotEmpty) {
      query = "?${Uri.encodeFull(query)}";
    }

    if (linkText.startsWith("gemini://")) {
      return Uri.parse(linkText);
    } else if (linkText.startsWith("//")) {
      return Uri.parse("gemini:$linkText");
    } else if (linkText.startsWith("/")) {
      // print("absolute path");
      return Uri.parse("gemini://${uri.host}$linkText$query");
    }
    final path = p.dirname(uri.path);

    if (p.extension(uri.path).isNotEmpty) {
      return Uri.parse("gemini://${uri.host}${p.join(path, linkText)}$query");
    }

    return Uri.parse("gemini://${uri.host}${p.join(uri.path, linkText)}$query");
  }

  Stream<Uint8List> connectStream(Uri url) async* {
    if (url.scheme != "gemini") {
      resolver(url);
      return;
    }
    this.uri = url;

    final socket = await SecureSocket.connect(
      uri.host,
      1965,
      onBadCertificate: (certificate) {
        return true;
      },
      // keyLog: (line) => print(line),
      timeout: Duration(seconds: 10),
    );

    final selector =
        "gemini://${uri.host}${uri.path}${uri.query.isNotEmpty ? '?' : ''}${uri.query}\r\n";
    socket.add(selector.codeUnits);
    print("selector: $selector");

    header = null;

    Stopwatch timer = Stopwatch();
    timer.start();

    List<int> buffer = [];

    bool redirect = false;

    await for (final value in socket) {
      print("got a new connection with length ${value.length}");
      buffer.addAll(value);

      if (timer.elapsedMilliseconds > 5000) {
        print("preloading resources");
        if (header == null) {
          _loadHeader(buffer);

          if (header!.status == 30 || header!.status == 31) {
            redirect = true;
            break;
          }
        }

        // streaming the new data to user
        if (header!.isGemtext) {
          _buffer = Uint8List.fromList(buffer);
          yield _buffer!;
        }
      }
    }

    await socket.close();

    _buffer = Uint8List.fromList(buffer);

    // print(utf8.decode(buffer));

    if (header == null) _loadHeader(buffer);

    redirect = (header!.status == 30 || header!.status == 31);

    if (redirect) {
      uri = resolve(header!.meta.replaceAll("\r", ""));
      await for (final value in connectStream(uri)) {
        yield value;
      }
      return;
    }
  }

  /// Make a connection to a gemini site.
  Future<void> connect(Uri url) async {
    print("connect() is called");
    await for (final _ in connectStream(url)) {
      print(_.length);
    }
    print("done! with connection $url");
  }

  _loadHeader(buffer) {
    print("decoding header");
    headerEnd = buffer.indexWhere((element) => element == 10);
    final line = utf8.decode(buffer.sublist(0, headerEnd));
    header = ResponseHeaderDecoder(line);
    print("the header: $header");
  }
}
