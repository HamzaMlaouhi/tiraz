import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/family_member.dart';

const _designGradient = [Color(0xFFE9DFCD), Color(0xFFDFE9E7)];

const _members = [
  FamilyMember(
    initial: LocalizedText(ar: 'أ', en: 'Y'),
    name: LocalizedText(ar: 'أنتِ — تفصيل', en: 'You — made-to-measure'),
    note: LocalizedText(ar: 'ملف «أنا» 14/14', en: 'Profile "Me" 14/14'),
    noteColor: AppColors.teal,
    priceAed: 920,
  ),
  FamilyMember(
    initial: LocalizedText(ar: 'س', en: 'S'),
    name: LocalizedText(ar: 'سارة — تفصيل', en: 'Sara — made-to-measure'),
    note: LocalizedText(ar: 'أكملي 4 قياسات متبقّية', en: 'Complete 4 remaining measurements'),
    noteColor: Color(0xFFA8742A),
    priceAed: 680,
  ),
  FamilyMember(
    initial: LocalizedText(ar: 'ل', en: 'L'),
    name: LocalizedText(ar: 'ليلى — جاهز', en: 'Layla — ready-to-wear'),
    note: LocalizedText(ar: 'مقاس 8 سنوات', en: 'Size 8 years'),
    noteColor: AppColors.textMuted,
    priceAed: 540,
  ),
];

class FamilySetPage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onOrdered;

  const FamilySetPage({super.key, required this.onBack, required this.onOrdered});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final totalAed = _members.fold(0, (sum, m) => sum + m.priceAed);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            Row(
              children: [
                RoundIconButton.back(onPressed: onBack),
                const SizedBox(width: 10),
                Text(l10n.familySetsTitle, style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(height: 150, decoration: const BoxDecoration(gradient: LinearGradient(colors: _designGradient, begin: Alignment.topLeft, end: Alignment.bottomRight))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.familySetDesignName, style: AppTextStyles.label.copyWith(fontSize: 14)),
                              Text(l10n.familySetSeller, style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
                            ],
                          ),
                        ),
                        Text(l10n.changeLabel, style: AppTextStyles.label.copyWith(color: AppColors.teal, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.familyWhoTitle, style: AppTextStyles.label),
            const SizedBox(height: 10),
            ..._members.map((member) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(color: Color(0xFFEFE9DD), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(member.initial.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 14, color: AppColors.textMutedAlt)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(member.name.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 13.5)),
                          Text(member.note.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11.5, color: member.noteColor)),
                        ],
                      ),
                    ),
                    Text(formatAed(member.priceAed, locale), style: AppTextStyles.priceSmall),
                  ],
                ),
              );
            }),
            const Divider(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(l10n.familyTotalLabel, style: AppTextStyles.bodyMuted.copyWith(fontSize: 13, height: 1))),
                Text(formatAed(totalAed, locale), style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: l10n.familyOrderCta,
              onPressed: () {
                final items = _members.map((m) {
                  return CartItem(
                    id: 'family-${m.initial.en}-${DateTime.now().millisecondsSinceEpoch}',
                    seller: const LocalizedText(ar: 'بيت الحرير — الشارقة', en: 'Silk House — Sharjah'),
                    leadLabel: const LocalizedText(ar: 'طقم العائلة', en: 'Family set'),
                    itemName: m.name,
                    variant: m.note,
                    priceAed: m.priceAed,
                    imageGradient: _designGradient,
                  );
                });
                sl<CartCubit>().addItems(items);
                onOrdered();
              },
            ),
          ],
        ),
      ),
    );
  }
}
