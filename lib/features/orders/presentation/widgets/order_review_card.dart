import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/order.dart';
import '../cubit/orders_cubit.dart';

/// On a delivered order: the rate-your-order form while [Order.canReview],
/// then the buyer's submitted review. Renders nothing otherwise.
class OrderReviewCard extends StatelessWidget {
  final Order order;

  const OrderReviewCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final review = order.review;
    if (review != null) return _SubmittedReview(review: review);
    if (order.canReview) return _ReviewForm(orderId: order.id);
    return const SizedBox.shrink();
  }
}

class _ReviewForm extends StatefulWidget {
  final String orderId;

  const _ReviewForm({required this.orderId});

  @override
  State<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final error = await sl<OrdersCubit>().submitReview(
      widget.orderId,
      rating: _rating,
      comment: _commentController.text,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    final l10n = AppLocalizations.of(context);
    // On success the cubit swaps this form for the submitted review.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error ?? l10n.orderRateThanks)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Card(
      children: [
        Text(l10n.orderRateTitle, style: AppTextStyles.h3),
        const SizedBox(height: 2),
        Text(l10n.orderRateSubtitle, style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
        const SizedBox(height: 10),
        _Stars(rating: _rating, size: 34, onChanged: _submitting ? null : (r) => setState(() => _rating = r)),
        const SizedBox(height: 10),
        TextField(
          controller: _commentController,
          enabled: !_submitting,
          minLines: 2,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(hintText: l10n.orderRateCommentHint),
        ),
        const SizedBox(height: 6),
        PrimaryButton(
          label: l10n.orderRateSubmit,
          loading: _submitting,
          onPressed: _rating == 0 || _submitting ? null : _submit,
        ),
      ],
    );
  }
}

class _SubmittedReview extends StatelessWidget {
  final OrderReview review;

  const _SubmittedReview({required this.review});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final comment = review.comment;
    return _Card(
      children: [
        Text(l10n.orderYourReview, style: AppTextStyles.label),
        const SizedBox(height: 6),
        _Stars(rating: review.rating, size: 20),
        if (comment != null && comment.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(comment, style: AppTextStyles.bodyMuted.copyWith(height: 1.5)),
        ],
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  final int rating;
  final double size;

  /// Null → read-only.
  final ValueChanged<int>? onChanged;

  const _Stars({required this.rating, required this.size, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final star = Icon(
          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: i < rating ? AppColors.gold : AppColors.chipUnselectedBorder,
        );
        final onChanged = this.onChanged;
        if (onChanged == null) return star;
        return InkResponse(
          onTap: () => onChanged(i + 1),
          radius: size * 0.7,
          child: Padding(padding: const EdgeInsetsDirectional.only(end: 4), child: star),
        );
      }),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;

  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}
