import 'package:app/app/theme/base.dart';
import 'package:app/features/setup/presentation/pages/setup_page.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> _openSetupForm(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      enableDrag: false,
      isScrollControlled: true,

      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 1,
          child: SetupPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PeriodtTheme.primary,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -40,
              left: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            // Middle-right circle bubble
            Positioned(
              top: 140,
              right: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            // Bottom-left circle bubble
            Positioned(
              bottom: 240,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Assets.animations.blobs.waving.lottie(
                        width: 273,
                      ),
                    ),
                  ),
                  Text(
                    'Welcome to Periodt!',
                    style: GoogleFonts.outfit(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'The private period tracking app built for you.',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _openSetupForm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PeriodtTheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
