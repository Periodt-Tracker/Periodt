import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:periodt/core/theme/app.dart';

class PeriodtNavbar extends StatelessWidget {
  const PeriodtNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = GoRouter.of(context);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(48),
              ),
              child: GNav(
                rippleColor:
                    Colors.grey[800]!, // tab button ripple color when pressed
                hoverColor: Colors.grey[700]!, // tab button hover color
                haptic: true, // haptic feedback
                tabBorderRadius: 32,
                curve: Curves.easeOutExpo, // tab animation curves
                duration: Duration(milliseconds: 400), // tab animation duration
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: PeriodtTheme.period.primary,
                tabMargin: EdgeInsetsGeometry.symmetric(horizontal: 8),
                iconSize: 28,
                gap: 8,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                tabs: [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: Icons.person, text: 'Likes'),
                  GButton(icon: Icons.search, text: 'Search'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => navigator.push("/daily-log"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: CircleBorder(), // makes the button circular
                padding: EdgeInsets.all(16), // adjust size of the circle
                minimumSize: Size(56, 56), // ensures minimum height and width
              ),
              child: Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
