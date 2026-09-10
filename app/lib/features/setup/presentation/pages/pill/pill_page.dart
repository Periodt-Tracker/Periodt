import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:flutter/material.dart';

class PillPage extends StatelessWidget {
  const PillPage(this._wizard, {super.key});

  final SetupWizardBloc _wizard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pill'),
      ),
      body: Center(
        child: Text('Pill Page'),
      ),
    );
  }
}
