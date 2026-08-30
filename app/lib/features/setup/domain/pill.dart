import 'package:app/features/setup/domain/regimen.dart';

enum ContraceptivePillType { cerelle }

sealed class ContraceptivePillDetails {
  const ContraceptivePillDetails();
}

class KnownContraceptivePill extends ContraceptivePillDetails {
  final ContraceptivePillType type;

  const KnownContraceptivePill({required this.type});
}

class CustomContraceptivePill extends ContraceptivePillDetails {
  final Regimen regimen;
  final bool suppressesOvulation;

  const CustomContraceptivePill({
    required this.regimen,
    required this.suppressesOvulation,
  });
}
