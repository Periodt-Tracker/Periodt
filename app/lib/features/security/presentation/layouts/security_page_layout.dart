import 'package:app/app/theme/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityPageLayout extends StatelessWidget {
  const SecurityPageLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PeriodtTheme.periodPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: child,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Periodt.',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
