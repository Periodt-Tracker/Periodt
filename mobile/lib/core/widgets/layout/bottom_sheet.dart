import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BottomSheetScreen extends HookWidget {
  final Widget child;

  const BottomSheetScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final routeAnimation =
        ModalRoute.of(context)?.animation ?? const AlwaysStoppedAnimation(1.0);

    return AnimatedBuilder(
      animation: routeAnimation,
      builder: (context, cachedChild) {
        final double dynamicRadius = Tween<double>(
          begin: 40.0,
          end: 0.0,
        ).transform(((routeAnimation.value - 0.85) / 0.15).clamp(0.0, 1.0));

        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(dynamicRadius),
            ),
          ),
          child: cachedChild,
        );
      },

      child: child,
    );
  }
}
