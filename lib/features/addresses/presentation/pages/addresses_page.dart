import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/dotted_add_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../cubit/addresses_cubit.dart';
import '../widgets/address_form_sheet.dart';

class AddressesPage extends StatefulWidget {
  final VoidCallback onBack;

  /// When opened from Checkout, picking an address also pops back there
  /// (Checkout re-reads the same singleton cubit, so no value needs to
  /// be threaded back through the route).
  final bool returnOnPick;

  const AddressesPage({super.key, required this.onBack, this.returnOnPick = false});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  @override
  void initState() {
    super.initState();
    sl<AddressesCubit>().load();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pick(String id) async {
    // Pop right away when picking for Checkout; the cubit already moved the
    // highlight optimistically and reverts itself if the server refuses.
    final pending = sl<AddressesCubit>().selectDefault(id);
    if (widget.returnOnPick) {
      widget.onBack();
      return;
    }
    final error = await pending;
    if (error != null && mounted) _showError(error);
  }

  Future<void> _delete(String id) async {
    final error = await sl<AddressesCubit>().delete(id);
    if (error != null && mounted) _showError(error);
  }

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
                    RoundIconButton.back(onPressed: widget.onBack),
                    const SizedBox(width: 10),
                    Text(l10n.addressesTitle, style: AppTextStyles.h2),
                  ],
                ),
                const SizedBox(height: 16),
                if (state.status == AddressesStatus.loading || state.status == AddressesStatus.initial)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.status == AddressesStatus.error)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Text(state.errorMessage ?? '', textAlign: TextAlign.center, style: AppTextStyles.bodyMuted),
                        const SizedBox(height: 10),
                        OutlinedButton(onPressed: sl<AddressesCubit>().load, child: Text(l10n.retry)),
                      ],
                    ),
                  )
                else if (state.addresses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(l10n.addressesEmpty, textAlign: TextAlign.center, style: AppTextStyles.bodyMuted),
                  ),
                ...state.addresses.map((address) {
                  final isDefault = address.id == state.defaultId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _pick(address.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: isDefault ? AppColors.teal : AppColors.border, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(address.label.resolve(locale),
                                            style: AppTextStyles.label.copyWith(fontSize: 13.5)),
                                        if (isDefault) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                                color: AppColors.tealBg, borderRadius: BorderRadius.circular(999)),
                                            child: Text(
                                              l10n.addressDefaultBadge,
                                              style:
                                                  AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.teal),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(address.line.resolve(locale),
                                        style: AppTextStyles.bodyMuted.copyWith(fontSize: 11.5, height: 1.6)),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textMuted),
                                onSelected: (action) {
                                  if (action == 'edit') showAddressFormSheet(context, address: address);
                                  if (action == 'delete') _delete(address.id);
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(value: 'edit', child: Text(l10n.addressEditAction)),
                                  PopupMenuItem(value: 'delete', child: Text(l10n.addressDeleteAction)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 4),
                if (state.status == AddressesStatus.loaded)
                  DottedAddButton(label: l10n.addressAddCta, onTap: () => showAddressFormSheet(context)),
              ],
            );
          },
        ),
      ),
    );
  }
}
