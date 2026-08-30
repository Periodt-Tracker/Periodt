import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:periodt/core/theme/app.dart';
import 'package:periodt/features/settings/widgets/settings_group.dart';

class SettingsRadioTile<T> extends StatelessWidget {
  final T value;
  // a seperate on changed notifier just for the inkwell
  final void Function(T?) onChanged;

  final String title;
  final String? description;

  const SettingsRadioTile({
    super.key,
    required this.title,
    this.description,
    required this.value,
    required this.onChanged,
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
                if (description != null) ...[
                  const SizedBox(height: 2),

                  Text(
                    description!,
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
          CupertinoRadio(
            value: value,
            activeColor: PeriodtTheme.period.primary,
          ),
        ],
      ),
    );
  }
}

class RadioTileOptions {
  final String title;
  final String? description;

  const RadioTileOptions({required this.title, this.description});
}

class SettingsRadioGroup<T> extends StatelessWidget {
  final T value;
  final Map<T, RadioTileOptions> values;
  final void Function(T?) onChanged;

  const SettingsRadioGroup({
    super.key,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: value,
      onChanged: onChanged,
      child: SettingsGroup(
        children: [
          for (final entry in values.entries) ...[
            SettingsRadioTile<T>(
              title: entry.value.title,
              description: entry.value.description,
              value: entry.key,
              onChanged: onChanged,
            ),
          ],
        ],
      ),
    );
  }
}
