import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:periodt/features/setup/widgets/setup_form.dart';
import 'package:periodt/gen/assets.gen.dart';

class SetupScreen extends HookWidget {
  const SetupScreen({super.key});

  final Color bgColor = const Color(0xFFE28585);
  final Color circleColor = const Color(0xFFE89898);

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 500),
    );

    void _openFormDrawer(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        transitionAnimationController: animationController,
        builder: (context) => const SetupForm(),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Top Left Circle
          Positioned(top: -50, left: -50, child: _buildCircle(250)),
          // Middle Right Circle
          Positioned(top: 200, right: -100, child: _buildCircle(300)),
          // Bottom Left Circle
          Positioned(bottom: 150, left: -80, child: _buildCircle(200)),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Center(
                    child: Image.asset(
                      Assets.blobs.welcome.welcome1024.path,
                      width: 256,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Welcome to Periodt!',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'The private period tracking app built for you.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () => _openFormDrawer(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: bgColor,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: circleColor.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
