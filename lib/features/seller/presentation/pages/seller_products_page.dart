import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/dotted_add_button.dart';
import '../cubit/seller_cubit.dart';
import '../widgets/seller_product_tile.dart';

class SellerProductsPage extends StatelessWidget {
  final VoidCallback onAddProduct;

  const SellerProductsPage({super.key, required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SellerCubit, SellerState>(
          bloc: sl<SellerCubit>(),
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Text(l10n.sellerProductsTitle, style: AppTextStyles.h1),
                const SizedBox(height: 4),
                Text(l10n.sellerProductsSubtitle(state.products.length.toString()), style: AppTextStyles.bodyMuted),
                const SizedBox(height: 16),
                GestureDetector(onTap: onAddProduct, child: DottedAddButton(label: l10n.sellerAddProductCta)),
                const SizedBox(height: 18),
                if (state.products.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(l10n.sellerNoProducts, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                    ),
                  )
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    children: state.products.map((p) {
                      return SellerProductTile(product: p, onRemove: () => sl<SellerCubit>().removeProduct(p.id));
                    }).toList(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
