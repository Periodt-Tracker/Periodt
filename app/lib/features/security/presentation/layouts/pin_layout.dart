import 'package:app/app/theme/base.dart';
import 'package:flutter/widgets.dart';

class PinLayout extends StatelessWidget {
  const PinLayout({
    required this.title,
    required this.pinInput,
    this.child,
    super.key,
  });

  final String title;
  final Widget pinInput;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 24,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: PeriodtTheme.light.textTheme.headlineLarge?.copyWith(
              color: PeriodtTheme.colorScheme.onPrimary,
            ),
          ),
          pinInput,
          ?child,
        ],
      ),
    );
  }
}
