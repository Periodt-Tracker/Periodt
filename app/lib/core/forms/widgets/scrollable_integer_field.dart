import 'package:app/app/theme/base.dart';
import 'package:app/core/forms/engine/field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PeriodtScrollableField<TRaw, TVal, E> extends StatelessWidget {
  const PeriodtScrollableField({
    required this.values,
    required this.field,
    required this.onChanged,
    required this.onTouched,
    required this.formatter,
    required this.errorText,
    super.key,
  });

  final PeriodtInput<TRaw, TVal, E> field;

  final String Function(TRaw) formatter;
  final String? Function(E) errorText;

  final List<TRaw> values;

  final void Function(TRaw) onChanged;
  final void Function() onTouched;

  Widget _buildDrawer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const FaIcon(FontAwesomeIcons.chevronLeft, size: 20),
              ),
              Expanded(
                child: Text(
                  'Select a value',
                  textAlign: TextAlign.center,
                  style: PeriodtTheme.light.textTheme.headlineMedium,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: CupertinoPicker.builder(
              itemExtent: 48,
              onSelectedItemChanged: (index) {
                onChanged(values[index]);
              },
              childCount: values.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    formatter(values[index]),
                    style: PeriodtTheme.light.textTheme.titleMedium,
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              textStyle: PeriodtTheme.light.textTheme.titleLarge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: _buildDrawer,
    );

    onTouched();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onPressed(context),
      child: Text(field.value != null ? formatter(field.value!) : 'Select'),
    );
  }
}
