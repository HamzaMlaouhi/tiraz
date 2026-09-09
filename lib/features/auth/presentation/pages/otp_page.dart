import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/role/role_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../cubit/auth_cubit.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: sl<AuthCubit>(),
      child: const _OtpView(),
    );
  }
}

class _OtpView extends StatelessWidget {
  const _OtpView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr.status == AuthStatus.verified && prev.status != AuthStatus.verified,
      listener: (context, state) => context.go(roleHomePath(sl<RoleCubit>().state)),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoundIconButton.back(onPressed: () => context.pop()),
                const Spacer(),
                Text(l10n.otpTitle, style: AppTextStyles.h1),
                const SizedBox(height: 6),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (p, c) => p.phone != c.phone,
                  builder: (context, state) => Text(
                    l10n.otpSubtitle(state.phone.isEmpty ? l10n.phoneHint : state.phone),
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
                const SizedBox(height: 22),
                Center(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: SizedBox(
                      width: 200,
                      child: BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (p, c) => p.otp != c.otp,
                        builder: (context, state) {
                          return TextField(
                            onChanged: context.read<AuthCubit>().otpChanged,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            textAlign: TextAlign.center,
                            maxLength: 4,
                            style: AppTextStyles.h1.copyWith(fontSize: 28, letterSpacing: 18),
                            decoration: const InputDecoration(counterText: '', hintText: '••••'),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (p, c) => p.resendSecondsLeft != c.resendSecondsLeft,
                    builder: (context, state) => Text(
                      state.resendSecondsLeft > 0
                          ? l10n.otpResend(state.resendSecondsLeft.toString().padLeft(2, '0'))
                          : l10n.otpResend('00'),
                      style: AppTextStyles.caption,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStatus.error && state.errorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(l10n.otpInvalid, style: AppTextStyles.bodyMuted.copyWith(color: AppColors.error)),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (p, c) => p.status != c.status || p.otp != c.otp,
                  builder: (context, state) {
                    return PrimaryButton(
                      label: l10n.otpVerifyCta,
                      loading: state.status == AuthStatus.verifying,
                      onPressed: state.otp.length == 4 ? () => context.read<AuthCubit>().verify() : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
