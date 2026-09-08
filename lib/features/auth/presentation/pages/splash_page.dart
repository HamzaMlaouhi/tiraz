import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2200), () {
      if (mounted) context.go('/auth');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF7F2E9), Color(0xFFEFE6D4)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.appName, style: AppTextStyles.splashWordmark),
              const SizedBox(height: 16),
              Container(height: 3, width: 76, color: AppColors.teal),
              const SizedBox(height: 16),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(l10n.appNameLatin, style: AppTextStyles.wordmarkLatin),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.splashTagline,
                style: AppTextStyles.body.copyWith(color: AppColors.sandText, fontSize: 13),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.teal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
