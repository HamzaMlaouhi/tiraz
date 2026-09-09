import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/role/role_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../cubit/auth_cubit.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => sl<AuthCubit>(),
      child: const _AuthView(),
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView();

  static const _emirateLabelKeys = kEmirateKeys;

  String _emirateLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'emirateDubai':
        return l10n.emirateDubai;
      case 'emirateAbuDhabi':
        return l10n.emirateAbuDhabi;
      case 'emirateSharjah':
        return l10n.emirateSharjah;
      default:
        return l10n.emirateOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr.status == AuthStatus.otpSent && prev.status != AuthStatus.otpSent,
      listener: (context, state) => context.push('/otp'),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () => context.read<LocaleCubit>().toggle(),
                    child: Text(l10n.switchToEnglish, style: AppTextStyles.buttonSecondary),
                  ),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(l10n.appName, style: AppTextStyles.h2.copyWith(fontSize: 30, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(l10n.appNameLatin,
                          style: AppTextStyles.wordmarkLatin.copyWith(fontSize: 11, letterSpacing: 4)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 3, width: 56, color: AppColors.teal),
                const SizedBox(height: 24),
                Text(l10n.authWelcome, style: AppTextStyles.h1),
                const SizedBox(height: 6),
                Text(l10n.authSubtitle, style: AppTextStyles.bodyMuted),
                const SizedBox(height: 22),
                Text(l10n.phoneNumberLabel, style: AppTextStyles.label),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: AppColors.border, width: 1.5),
                        ),
                        child: Text('+971', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (p, c) => p.phone != c.phone,
                          builder: (context, state) {
                            return TextField(
                              onChanged: context.read<AuthCubit>().phoneChanged,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9)
                              ],
                              style: AppTextStyles.label.copyWith(fontSize: 15),
                              decoration: InputDecoration(hintText: l10n.phoneHint),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(l10n.emirateLabel, style: AppTextStyles.label),
                const SizedBox(height: 8),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (p, c) => p.emirateIndex != c.emirateIndex,
                  builder: (context, state) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_emirateLabelKeys.length, (i) {
                        return SelectableChip(
                          label: _emirateLabel(l10n, _emirateLabelKeys[i]),
                          selected: state.emirateIndex == i,
                          onTap: () => context.read<AuthCubit>().emirateSelected(i),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 26),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStatus.error && state.errorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child:
                            Text(state.errorMessage!, style: AppTextStyles.bodyMuted.copyWith(color: AppColors.error)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (p, c) => p.status != c.status || p.phone != c.phone,
                  builder: (context, state) {
                    return PrimaryButton(
                      label: l10n.sendCodeCta,
                      loading: state.status == AuthStatus.submittingPhone,
                      onPressed: state.phone.trim().isEmpty ? null : () => context.read<AuthCubit>().sendCode(),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(roleHomePath(sl<RoleCubit>().state)),
                    child: Text(
                      l10n.browseAsGuest,
                      style: AppTextStyles.buttonSecondary.copyWith(
                        color: AppColors.teal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
