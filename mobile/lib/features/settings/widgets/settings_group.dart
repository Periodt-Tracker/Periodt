import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:periodt/features/settings/widgets/settings_divider.dart';

class SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroup({super.key, required this.children});

  List<Widget> _buildChildrenWithDividers() {
    List<Widget> result = [];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);

      if (i < children.length - 1) {
        result.add(const SettingsDivider());
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(children: _buildChildrenWithDividers()),
      ),
    );
  }
}
