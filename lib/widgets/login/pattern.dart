import 'package:flutter/material.dart';

class PatternWidget extends StatelessWidget {
  final Widget child;
  final double curvedDistance;
  final double curvedHeight;

  const PatternWidget(
      {Key key, this.curvedDistance = 80, this.curvedHeight = 80, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PatternWidgetBackgroundClipper(
          curvedDistance: curvedDistance, curvedHeight: curvedHeight),
      child: child,
    );
  }
}

class PatternWidgetBackgroundClipper extends CustomClipper<Path> {
  final double curvedDistance;
  final double curvedHeight;

  PatternWidgetBackgroundClipper({this.curvedDistance, this.curvedHeight});

  @override
  getClip(Size size) {
    Path clippedPath = Path();
    clippedPath.lineTo(size.width, 0);
    clippedPath.lineTo(size.width, size.height - curvedDistance - curvedHeight-150);
    clippedPath.lineTo(size.width / 3, 3 * (size.height-100) / 4);
    clippedPath.addPolygon([
      Offset.zero,
      Offset(size.width / 3, 3 * (size.height-100) / 4),
      Offset(0, size.height)
    ], true);
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
} 