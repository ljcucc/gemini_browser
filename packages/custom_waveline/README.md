## Custom Waveline for Flutter

This package provides a customizable wave-shaped divider widget for Flutter. You can customize the width and height of the wave, the stroke width, and the color.

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_waveline: ^1.0.0
```

Then, run the following command in your terminal:

```bash
flutter pub get
```

### Usage

Import the package into your Dart file:

```dart
import 'package:custom_waveline/custom_waveline.dart';
```

Use the `CustomWaveline` widget in your build method:

```dart
CustomPaint(
  size: Size.fromHeight(60),
  painter: CustomWaveline(
    color: Colors.blue, // Customize the color
    strokeWidth: 2, // Customize the stroke width
    curveWidth: 24, // Customize the width of each wave
    curveHeight: 4, // Customize the height of each wave
  ),
),
```

### Example

```dart
import 'package:custom_waveline/custom_waveline.dart';
import 'package:flutter/material.dart';

class WavelineDivider extends StatelessWidget {
  const WavelineDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CustomPaint(
          size: Size.fromHeight(60),
          painter: CustomWaveline(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            strokeWidth: 2,
            curveWidth: 24,
            curveHeight: 4,
          ),
        ),
      ),
    );
  }
}
```

### Contributing

Feel free to contribute to the package by opening issues and pull requests.
