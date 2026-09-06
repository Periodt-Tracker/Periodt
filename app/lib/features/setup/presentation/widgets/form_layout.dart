import 'package:app/app/theme/base.dart';
import 'package:flutter/material.dart';

class FormLayout extends StatelessWidget {
  const FormLayout({
    super.key,
    required this.title,
    required this.child,
    required this.buttonText,
    required this.onSubmit,
  });

  final String title;
  final Widget child;
  final String buttonText;
  final void Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: PeriodtTheme.light.textTheme.headlineLarge,
          ),
          child,
          const Spacer(),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
