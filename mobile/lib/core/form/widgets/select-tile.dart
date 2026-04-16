// Copyright (c) Periodt. 2026
//
// This file is part of Periodt and licensed under the PSAL v1.0.
// See the LICENSE file for details.
//
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/theme/app.dart';

class SelectTile extends HookWidget {
  final Widget child;
  final bool selected;
  final VoidCallback? onTap;

  const SelectTile({
    super.key,
    this.onTap,
    required this.selected,
    required this.child,
  });

  Widget _radioIndicator() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: PeriodtTheme.period.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: Color.fromARGB(100, 232, 232, 232),
      onTap: onTap,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: selected ? PeriodtTheme.period.primary : Colors.black12,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: child,
          ),

          if (selected) Positioned(top: 8, left: 8, child: _radioIndicator()),
        ],
      ),
    );
  }
}
