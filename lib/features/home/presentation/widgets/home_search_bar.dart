import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The home feed's search field — an always-visible bar that grows a teal
/// glow on focus, and swaps to a live-filtered result view (driven by
/// [onChanged], in the parent) as the shopper types.
class HomeSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const HomeSearchBar({super.key, required this.onChanged});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _focused ? AppColors.teal : AppColors.border, width: _focused ? 1.6 : 1.2),
        boxShadow: _focused
            ? [BoxShadow(color: AppColors.teal.withOpacity(0.16), blurRadius: 18, offset: const Offset(0, 6))]
            : const [],
      ),
      child: Row(
        children: [
          AnimatedScale(
            scale: _focused ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: Icon(Icons.search_rounded, size: 20, color: _focused ? AppColors.teal : AppColors.textMuted),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (value) {
                widget.onChanged(value);
                setState(() {});
              },
              style: AppTextStyles.label.copyWith(fontSize: 13.5),
              decoration: InputDecoration(
                isCollapsed: true,
                filled: false,
                border: InputBorder.none,
                hintText: l10n.searchHint,
                hintStyle: AppTextStyles.bodyMuted.copyWith(fontSize: 13),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: FadeTransition(opacity: anim, child: child)),
            child: _controller.text.isEmpty
                ? const SizedBox.shrink(key: ValueKey('empty'))
                : GestureDetector(
                    key: const ValueKey('clear'),
                    onTap: _clear,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close_rounded, size: 17, color: AppColors.textMuted),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
