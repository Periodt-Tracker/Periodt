import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:periodt/core/theme/app.dart';

class SettingToggleTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconBackgroundColor;
  final bool value;
  final bool disabled;
  final ValueChanged<bool> onChanged;

  const SettingToggleTile({
    super.key,
    required this.title,
    this.icon,
    this.iconBackgroundColor,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(
            height: 30,
            child: VerticalDivider(width: 20, thickness: 0.5),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: PeriodtTheme.period.primary,
            onChanged: disabled ? null : onChanged,
          ),
        ],
      ),
    );
  }
}
