import 'package:flutter/material.dart';

class CurvedDivider extends StatelessWidget {
  final Color color;
  final double height;

  const CurvedDivider({super.key, required this.color, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipPath(
        clipper: _CurveClipper(height: height),
        child: Container(color: color),
      ),
    );
  }
}

class _CurveClipper extends CustomClipper<Path> {
  final double height;

  _CurveClipper({required this.height});

  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, 0);
    path.lineTo(0, height);

    path.quadraticBezierTo(size.width / 2, -height, size.width, height);
    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
