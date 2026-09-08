import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../cubit/measurement_entry_cubit.dart';

class MeasurementEntryPage extends StatelessWidget {
  final String profileName;
  final VoidCallback onBack;
  final VoidCallback onDone;

  const MeasurementEntryPage({super.key, required this.profileName, required this.onBack, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MeasurementEntryCubit>(
      create: (_) => MeasurementEntryCubit(),
      child: _EntryView(profileName: profileName, onBack: onBack, onDone: onDone),
    );
  }
}

class _EntryView extends StatelessWidget {
  final String profileName;
  final VoidCallback onBack;
  final VoidCallback onDone;

  const _EntryView({required this.profileName, required this.onBack, required this.onDone});

  (String, String) _stepCopy(AppLocalizations l10n, String key) {
    switch (key) {
      case 'shoulder':
        return (l10n.measureStepShoulderName, l10n.measureStepShoulderTip);
      case 'bust':
        return (l10n.measureStepBustName, l10n.measureStepBustTip);
      default:
        return (l10n.measureStepWaistName, l10n.measureStepWaistTip);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MeasurementEntryCubit, MeasurementEntryState>(
          builder: (context, state) {
            final (stepName, stepTip) = _stepCopy(l10n, state.stepKey);

            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      RoundIconButton.back(onPressed: onBack),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profileName, style: AppTextStyles.label.copyWith(fontSize: 14)),
                            Text(
                              l10n.entryStepLabel(state.stepNumber.toString(), state.totalSteps.toString()),
                              style: AppTextStyles.caption.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: state.progress,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFEFE9DD),
                      valueColor: const AlwaysStoppedAnimation(AppColors.teal),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Text(stepName, style: AppTextStyles.h3),
                            const SizedBox(height: 14),
                            Container(
                              width: 170,
                              height: 150,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFEFE9DD), borderRadius: BorderRadius.circular(12)),
                              alignment: Alignment.center,
                              child: Text(
                                l10n.measureIllustrationPlaceholder,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption.copyWith(fontSize: 11, height: 1.6),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(stepTip,
                                textAlign: TextAlign.center, style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
                            const SizedBox(height: 16),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: _ValueField(
                                      key: ValueKey(state.stepIndex),
                                      initialValue: state.value,
                                      onChanged: context.read<MeasurementEntryCubit>().valueChanged,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(l10n.measureUnitCm, style: AppTextStyles.bodyMuted),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n.measureAltMeasure,
                        style: AppTextStyles.buttonSecondary
                            .copyWith(color: AppColors.teal, decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              state.stepIndex == 0 ? null : () => context.read<MeasurementEntryCubit>().previous(),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.card,
                            side: const BorderSide(color: AppColors.border, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          ),
                          child: Text(l10n.entryBack, style: AppTextStyles.buttonSecondary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          label: l10n.entryNext,
                          onPressed: () {
                            final finished = context.read<MeasurementEntryCubit>().next();
                            if (finished) onDone();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Owns its own controller so retyping a digit doesn't fight a
/// rebuild-recreated `TextEditingController` for cursor position — only
/// remounts (via the `ValueKey(stepIndex)` above) when the step changes.
class _ValueField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _ValueField({super.key, required this.initialValue, required this.onChanged});

  @override
  State<_ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<_ValueField> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      // Digits with at most one decimal point — e.g. "92" or "92.5" — so a
      // physical keyboard can't type letters or a second ".".
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
      textAlign: TextAlign.center,
      style: AppTextStyles.h1.copyWith(fontSize: 20),
    );
  }
}
