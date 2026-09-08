import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/dotted_add_button.dart';
import '../cubit/fit_cubit.dart';

class MeasurementProfilesPage extends StatelessWidget {
  final void Function(String profileId, String profileName) onOpenEntry;

  const MeasurementProfilesPage({super.key, required this.onOpenEntry});

  @override
  Widget build(BuildContext context) {
    // FitCubit is a singleton (Account's row count reads it too), so it
    // is looked up straight from `sl`, never handed to a `BlocProvider`
    // that would `close()` it when this page is popped.
    return _FitView(onOpenEntry: onOpenEntry);
  }
}

class _FitView extends StatelessWidget {
  final void Function(String profileId, String profileName) onOpenEntry;

  const _FitView({required this.onOpenEntry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<FitCubit, FitState>(
          bloc: sl<FitCubit>(),
          builder: (context, state) {
            if (state.status == FitStatus.loading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.teal));
            }
            if (state.status == FitStatus.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.genericError, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: () => sl<FitCubit>().load(), child: Text(l10n.retry)),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Text(l10n.navMyFit, style: AppTextStyles.h2),
                const SizedBox(height: 4),
                Text(l10n.fitSubtitle, style: AppTextStyles.bodyMuted.copyWith(height: 1.6)),
                const SizedBox(height: 16),
                ...state.profiles.map((profile) {
                  final ringBg = profile.isComplete
                      ? AppColors.tealBg
                      : (profile.completedCount > 0 ? AppColors.sandBg : const Color(0xFFEFE9DD));
                  final ringFg = profile.isComplete
                      ? AppColors.tealDark
                      : (profile.completedCount > 0 ? AppColors.sandText : AppColors.textMuted);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => onOpenEntry(profile.id, profile.name.resolve(locale)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(color: ringBg, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text(
                                  '${profile.completedCount}/${profile.totalCount}',
                                  style: AppTextStyles.caption.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: ringFg),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(profile.name.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 14)),
                                    Text(profile.statusLabel.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: Color(0xFFC9C0B0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 4),
                DottedAddButton(label: l10n.fitAddProfileCta),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(color: AppColors.sandBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(l10n.fitTip, style: AppTextStyles.bodyMuted.copyWith(color: AppColors.sandText, fontSize: 11.5)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
