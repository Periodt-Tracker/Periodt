import 'package:app/app/theme/base.dart';
import 'package:app/features/security/domain/pin.dart';
import 'package:flutter/widgets.dart';
import 'package:pinput/pinput.dart';

class PinInput extends StatelessWidget {
  const PinInput({
    this.onPinEntered,
    this.autofocus = true,
    this.obscureText = true,
    this.enabled = true,
    super.key,
  });

  final void Function(PinType)? onPinEntered;
  final bool autofocus;
  final bool obscureText;

  final bool enabled;

  void _onCompleted(String pin) {
    onPinEntered?.call(PinType(pin));
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: PeriodtTheme.primaryLight,
      ),
      textStyle: TextStyle(
        fontSize: 24,
        color: PeriodtTheme.colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    );

    return Pinput(
      key: key,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration?.copyWith(
          border: Border.all(
            color: PeriodtTheme.colorScheme.onPrimary,
            strokeAlign: BorderSide.strokeAlignOutside,
            width: 4,
          ),
        ),
      ),
      disabledPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration?.copyWith(
          color: PeriodtTheme.primaryDark,
        ),
      ),
      autofocus: autofocus,
      obscureText: obscureText,
      onCompleted: _onCompleted,
      enabled: enabled,
    );
  }
}
