import 'package:flutter/material.dart';

// class ShapedIconData {
//   final IconData icon;
//   final Color? color;
//   final ShapeTypes? shape;
//   final double? degree;

//   ShapedIconData({
//     required this.icon,
//     this.color,
//     this.shape,
//     this.degree,
//   });
// }

enum ShapeTypes {
  Triangle,
  Scallop,
  Clover,
  Circle,
  // Drop,
}

class ShapedIcon extends StatelessWidget {
  final Widget child;
  final Color color;
  final ShapeTypes shape;
  final double degree;

  const ShapedIcon({
    super.key,
    required this.child,
    required this.color,
    required this.shape,
    required this.degree,
  });

  @override
  Widget build(BuildContext context) {
    Decoration decoration =
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(32));

    switch (shape) {
      case ShapeTypes.Scallop:
        decoration = ShapeDecoration(
          color: color,
          shape: StarBorder(
            points: 8,
            innerRadiusRatio: 0.75,
            valleyRounding: 0.5,
            pointRounding: 0.5,
          ),
        );
        break;
      case ShapeTypes.Circle:
        decoration = BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1000),
        );
        break;
      case ShapeTypes.Clover:
        decoration = ShapeDecoration(
          color: color,
          shape: StarBorder(
            points: 4,
            rotation: degree,
            innerRadiusRatio: 0.35,
            valleyRounding: 0.25,
            pointRounding: 0.75,
          ),
        );
        break;
      case ShapeTypes.Triangle:
        decoration = ShapeDecoration(
          color: color,
          shape: StarBorder(
            points: 3,
            rotation: degree,
            innerRadiusRatio: 0.35,
            valleyRounding: 0.25,
            pointRounding: 0.75,
          ),
        );
      // case ShapeTypes.Drop:
      //   decoration = BoxDecoration(
      //     color: color,
      //     borderRadius: BorderRadius.circular(100).copyWith(
      //       topLeft: Radius.circular(32),
      //     ),
      //   );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Transform.scale(
        alignment: Alignment.center,
        scale: shape == ShapeTypes.Circle ? 0.92 : 1,
        child: Container(
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}
