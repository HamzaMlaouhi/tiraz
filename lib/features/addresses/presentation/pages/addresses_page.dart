import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/dotted_add_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../cubit/addresses_cubit.dart';

class AddressesPage extends StatelessWidget {
  final VoidCallback onBack;

  /// When opened from Checkout, picking an address also pops back there
  /// (Checkout re-reads the same singleton cubit, so no value needs to
  /// be threaded back through the route).
  final bool returnOnPick;

  const AddressesPage({super.key, required this.onBack, this.returnOnPick = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AddressesCubit, AddressesState>(
          bloc: sl<AddressesCubit>(),
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Row(
                  children: [
                    RoundIconButton.back(onPressed: onBack),
                    const SizedBox(width: 10),
                    Text(l10n.addressesTitle, style: AppTextStyles.h2),
                  ],
                ),
                const SizedBox(height: 16),
                ...state.addresses.map((address) {
                  final isDefault = address.id == state.defaultId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          sl<AddressesCubit>().selectDefault(address.id);
                          if (returnOnPick) onBack();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: isDefault ? AppColors.teal : AppColors.border, width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(address.label.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 13.5)),
                                  if (isDefault) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(color: AppColors.tealBg, borderRadius: BorderRadius.circular(999)),
                                      child: Text(
                                        l10n.addressDefaultBadge,
                                        style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.teal),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(address.line.resolve(locale), style: AppTextStyles.bodyMuted.copyWith(fontSize: 11.5, height: 1.6)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 4),
                DottedAddButton(label: l10n.addressAddCta),
              ],
            );
          },
        ),
      ),
    );
  }
}
