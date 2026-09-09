import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../cubit/seller_cubit.dart';

class AddProductPage extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSaved;

  const AddProductPage({super.key, required this.onBack, required this.onSaved});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isMadeToMeasure = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty && (double.tryParse(_priceController.text) ?? 0) > 0;

  void _save() {
    if (!_canSave) return;
    sl<SellerCubit>().addProduct(
      name: _nameController.text,
      priceAed: double.parse(_priceController.text),
      isMadeToMeasure: _isMadeToMeasure,
    );
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  RoundIconButton.back(onPressed: widget.onBack),
                  const SizedBox(width: 10),
                  Text(l10n.sellerAddProductTitle, style: AppTextStyles.h2),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.sellerProductNameLabel, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(hintText: l10n.sellerProductNameHint),
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.sellerPriceLabel, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _priceController,
                        onChanged: (_) => setState(() {}),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        // Digits with at most one decimal point, matching
                        // the measurement-entry field's convention.
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                        decoration: InputDecoration(hintText: l10n.sellerPriceHint),
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.sellerProductTypeLabel, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          SelectableChip(
                            label: l10n.readyToWear,
                            selected: !_isMadeToMeasure,
                            onTap: () => setState(() => _isMadeToMeasure = false),
                          ),
                          SelectableChip(
                            label: l10n.madeToMeasure,
                            selected: _isMadeToMeasure,
                            onTap: () => setState(() => _isMadeToMeasure = true),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(label: l10n.sellerSaveProductCta, onPressed: _canSave ? _save : null),
            ],
          ),
        ),
      ),
    );
  }
}
