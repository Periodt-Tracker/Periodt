import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const SettingsIcon({
    super.key,
    required this.icon,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: foregroundColor, size: 16),
    );
  }
}
