import 'package:flutter_test/flutter_test.dart';
import 'package:gemini_browser/utils/url_resolve.dart';

void main() {
  test('navigateToPath test ', () {
    expect(
      navigateToPath("/test/index.gmi", "assets/fig1.jpg"),
      "/test/assets/fig1.jpg",
    );

    expect(
      navigateToPath("/test/ep1/index.gmi", "../assets/fig1.jpg"),
      "/test/assets/fig1.jpg",
    );
  });
}
