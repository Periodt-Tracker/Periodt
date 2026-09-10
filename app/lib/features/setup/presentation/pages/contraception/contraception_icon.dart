import 'package:app/features/setup/presentation/pages/contraception/contraception_field.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ContraceptionIcon extends StatelessWidget {
  const ContraceptionIcon({
    required this.method,
    this.size = 24.0,
    super.key,
  });

  final Method method;
  final double size;

  @override
  Widget build(BuildContext context) {
    final asset = switch (method) {
      Method.copperIud => Assets.images.icons.contraception.copperIud512,
      Method.hormonalIud => Assets.images.icons.contraception.hormonalIud512,
      Method.pill => Assets.images.icons.contraception.pill512,
      Method.none => Assets.images.icons.contraception.noneIcon512,
    };

    return asset.image(width: size, height: size);
  }
}
