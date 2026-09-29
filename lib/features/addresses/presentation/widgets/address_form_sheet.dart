import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../../domain/entities/address.dart';
import '../cubit/addresses_cubit.dart';

/// Opens the add (when [address] is null) or edit sheet.
Future<void> showAddressFormSheet(BuildContext context, {Address? address}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _AddressFormSheet(address: address),
  );
}

// The label is picked from fixed chips so it can be stored bilingually;
// the street line is free text the user types once, stored under both
// languages (it's an address, not UI copy).
const _labelPresets = [
  LocalizedText(ar: 'المنزل', en: 'Home'),
  LocalizedText(ar: 'العمل', en: 'Work'),
  LocalizedText(ar: 'أخرى', en: 'Other'),
];

class _AddressFormSheet extends StatefulWidget {
  final Address? address;

  const _AddressFormSheet({this.address});

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  late final TextEditingController _lineController;
  late int _labelIndex;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _lineController = TextEditingController(text: address == null ? '' : address.line.en);
    final match = address == null ? -1 : _labelPresets.indexWhere((p) => p.en == address.label.en);
    _labelIndex = match == -1 ? 0 : match;
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final line = _lineController.text.trim();
    if (line.isEmpty) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final error = await sl<AddressesCubit>().save(
      id: widget.address?.id,
      label: _labelPresets[_labelIndex],
      line: LocalizedText(ar: line, en: line),
    );
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _saving = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [l10n.addressLabelHome, l10n.addressLabelWork, l10n.addressLabelOther];

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 18, 18, 18 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.address == null ? l10n.addressFormAddTitle : l10n.addressFormEditTitle,
              style: AppTextStyles.h3),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: List.generate(labels.length, (i) {
              return SelectableChip(
                label: labels[i],
                selected: _labelIndex == i,
                onTap: () => setState(() => _labelIndex = i),
                pill: true,
              );
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _lineController,
            autofocus: widget.address == null,
            minLines: 1,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(hintText: l10n.addressLineHint, errorText: _error),
          ),
          const SizedBox(height: 14),
          PrimaryButton(label: l10n.addressSaveCta, onPressed: _saving ? null : _save, loading: _saving),
        ],
      ),
    );
  }
}
