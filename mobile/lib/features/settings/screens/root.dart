import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:periodt/core/theme/app.dart';
import 'package:periodt/features/settings/widgets/settings_group.dart';
import 'package:periodt/features/settings/widgets/settings_tile.dart';

class SettingsRootScreen extends ConsumerWidget {
  const SettingsRootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = GoRouter.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Settings', style: TextStyle(color: Colors.black)),
              centerTitle: true, // Centers the title when collapsed
              collapseMode: CollapseMode.pin,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SettingsGroup(
                children: [
                  SettingsTile(
                    title: "Profile",
                    icon: Icons.person,
                    iconBackgroundColor: PeriodtTheme.period.primary,
                    onTap: () => navigator.push("/settings/profile"),
                  ),
                  SettingsTile(
                    title: "My Cycle",
                    icon: Icons.water_drop,
                    iconBackgroundColor: PeriodtTheme.period.primary,
                    onTap: () => navigator.push("/settings/cycle"),
                  ),
                ],
              ),
              SettingsGroup(
                children: [
                  SettingsTile(
                    title: "Security",
                    icon: Icons.shield,
                    iconBackgroundColor: PeriodtTheme.period.primary,
                    onTap: () => navigator.push("/settings/security"),
                  ),
                  SettingsTile(
                    title: "Notifications",
                    icon: Icons.notifications,
                    iconBackgroundColor: PeriodtTheme.period.primary,
                    onTap: () => navigator.push("/settings/security"),
                  ),
                ],
              ),
              SettingsGroup(
                children: [
                  SettingsTile(
                    title: "Developer Options",
                    icon: Icons.developer_board_rounded,
                    iconBackgroundColor: PeriodtTheme.period.primary,
                    onTap: () => navigator.push("/settings/developer"),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
