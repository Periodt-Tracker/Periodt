import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PulseBox extends HookWidget {
  final double width;
  final double height;
  final double borderRadius;

  const PulseBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 800),
    );

    useEffect(() {
      controller.repeat(reverse: true);
      return null;
    }, const []);

    final color = useAnimation(
      ColorTween(
        begin: Colors.grey.shade300,
        end: Colors.grey.shade100,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut)),
    );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
