import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../../domain/entities/jalabiya_quality.dart';
import '../cubit/seller_cubit.dart';
import '../widgets/seller_product_image.dart';

class AddProductPage extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSaved;

  const AddProductPage({super.key, required this.onBack, required this.onSaved});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // Deterministic placeholder photography (see FadeInNetworkImage) styled
  // as a small "pick one" gallery — the safe default alongside a real
  // device upload.
  static const _stockPhotoSeeds = [
    'tiraz-gallery-1',
    'tiraz-gallery-2',
    'tiraz-gallery-3',
    'tiraz-gallery-4',
    'tiraz-gallery-5',
    'tiraz-gallery-6',
  ];
  static String _stockPhotoUrl(String seed) => 'https://picsum.photos/seed/$seed/500/650';

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _lengthController = TextEditingController();
  final _chestController = TextEditingController();
  final _sleeveController = TextEditingController();
  final _extraCostController = TextEditingController();

  bool _isMadeToMeasure = false;
  bool _isHandmade = false;
  JalabiyaQuality _quality = JalabiyaQuality.standard;

  late String _imageUrl = _stockPhotoUrl(_stockPhotoSeeds.first);
  Uint8List? _imageBytes;
  bool _isPickingPhoto = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _lengthController.dispose();
    _chestController.dispose();
    _sleeveController.dispose();
    _extraCostController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _nameController.text.trim().isNotEmpty &&
      (double.tryParse(_priceController.text) ?? 0) > 0 &&
      (double.tryParse(_lengthController.text) ?? 0) > 0 &&
      (double.tryParse(_chestController.text) ?? 0) > 0 &&
      (double.tryParse(_sleeveController.text) ?? 0) > 0;

  Future<void> _pickFromDevice() async {
    setState(() => _isPickingPhoto = true);
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 85);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() => _imageBytes = bytes);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).sellerPhotoUploadError)));
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
    }
  }

  void _chooseStockPhoto(String seed) {
    setState(() {
      _imageBytes = null;
      _imageUrl = _stockPhotoUrl(seed);
    });
  }

  String _qualityLabel(AppLocalizations l10n, JalabiyaQuality quality) {
    switch (quality) {
      case JalabiyaQuality.standard:
        return l10n.sellerQualityStandard;
      case JalabiyaQuality.premium:
        return l10n.sellerQualityPremium;
      case JalabiyaQuality.luxury:
        return l10n.sellerQualityLuxury;
    }
  }

  void _save() {
    if (!_canSave) return;
    sl<SellerCubit>().addProduct(
      name: _nameController.text,
      description: _descriptionController.text,
      priceAed: double.parse(_priceController.text),
      isMadeToMeasure: _isMadeToMeasure,
      isHandmade: _isHandmade,
      handmadeExtraCostAed: double.tryParse(_extraCostController.text) ?? 0,
      lengthCm: double.parse(_lengthController.text),
      chestCm: double.parse(_chestController.text),
      sleeveCm: double.parse(_sleeveController.text),
      quality: _quality,
      imageUrl: _imageUrl,
      imageBytes: _imageBytes,
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
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.sellerPhotoLabel, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SellerProductImage(
                          imageUrl: _imageUrl,
                          imageBytes: _imageBytes,
                          width: double.infinity,
                          height: 180,
                          fallback: const DecoratedBox(decoration: BoxDecoration(color: AppColors.tealBg)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _isPickingPhoto ? null : _pickFromDevice,
                        icon: _isPickingPhoto
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.teal),
                              )
                            : const Icon(Icons.upload_rounded, size: 18, color: AppColors.teal),
                        label: Text(l10n.sellerPhotoUploadCta,
                            style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.teal)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          backgroundColor: AppColors.card,
                          side: const BorderSide(color: AppColors.teal, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(l10n.sellerPhotoGalleryLabel, style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 64,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _stockPhotoSeeds.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final seed = _stockPhotoSeeds[i];
                            final selected = _imageBytes == null && _imageUrl == _stockPhotoUrl(seed);
                            return GestureDetector(
                              onTap: () => _chooseStockPhoto(seed),
                              child: Container(
                                width: 64,
                                height: 64,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: selected ? AppColors.teal : Colors.transparent, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: SellerProductImage(
                                    imageUrl: _stockPhotoUrl(seed),
                                    width: 60,
                                    height: 60,
                                    fallback: const DecoratedBox(decoration: BoxDecoration(color: AppColors.tealBg)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.sellerProductNameLabel, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(hintText: l10n.sellerProductNameHint),
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.sellerDetailsLabel, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(hintText: l10n.sellerDetailsHint),
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.sellerDimensionsLabel, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                              child: _DimensionField(
                                  label: l10n.sellerLengthLabel,
                                  controller: _lengthController,
                                  onChanged: () => setState(() {}))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _DimensionField(
                                  label: l10n.sellerChestLabel,
                                  controller: _chestController,
                                  onChanged: () => setState(() {}))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _DimensionField(
                                  label: l10n.sellerSleeveLabel,
                                  controller: _sleeveController,
                                  onChanged: () => setState(() {}))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.sellerPriceLabel, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _priceController,
                        onChanged: (_) => setState(() {}),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                      const SizedBox(height: 20),
                      Text(l10n.sellerQualityLabel, style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: JalabiyaQuality.values.map((quality) {
                          return SelectableChip(
                            label: _qualityLabel(l10n, quality),
                            selected: _quality == quality,
                            onTap: () => setState(() => _quality = quality),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.sellerHandmadeToggleLabel,
                                          style: AppTextStyles.label.copyWith(fontSize: 13.5)),
                                      const SizedBox(height: 2),
                                      Text(l10n.sellerHandmadeToggleSubtitle,
                                          style: AppTextStyles.caption.copyWith(fontSize: 11)),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _isHandmade,
                                  activeColor: AppColors.teal,
                                  onChanged: (value) => setState(() => _isHandmade = value),
                                ),
                              ],
                            ),
                            if (_isHandmade) ...[
                              const SizedBox(height: 10),
                              Text(l10n.sellerHandmadeExtraCostLabel,
                                  style: AppTextStyles.label.copyWith(fontSize: 12.5)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _extraCostController,
                                onChanged: (_) => setState(() {}),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                                decoration: InputDecoration(hintText: l10n.sellerPriceHint),
                              ),
                            ],
                          ],
                        ),
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

class _DimensionField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _DimensionField({required this.label, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 11)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: (_) => onChanged(),
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
          decoration: const InputDecoration(hintText: '0', contentPadding: EdgeInsets.symmetric(vertical: 12)),
        ),
      ],
    );
  }
}
