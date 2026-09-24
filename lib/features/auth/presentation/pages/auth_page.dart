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
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const _AuthHero(),
            Expanded(
              // Pulls the card up over the hero's bottom edge — a plain
              // box-constraint Column (not Stack/Positioned math), so it
              // stays keyboard-safe: Transform only shifts paint position,
              // the layout slot Expanded gives it is unaffected.
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(l10n.authWelcome, style: AppTextStyles.h1),
                          const SizedBox(height: 8),
                          Text(l10n.authFormSubtitle, style: AppTextStyles.bodyMuted),
                          const SizedBox(height: 28),
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('+971', style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.keyboard_arrow_down_rounded,
                                          size: 18, color: AppColors.textMuted),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: 1,
                                    height: 22,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    color: AppColors.border),
                                Expanded(
                                  child: BlocBuilder<AuthCubit, AuthState>(
                                    buildWhen: (p, c) => p.phone != c.phone,
                                    builder: (context, state) {
                                      return TextField(
                                        onChanged: context.read<AuthCubit>().phoneChanged,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(9),
                                        ],
                                        style: AppTextStyles.label.copyWith(fontSize: 15),
                                        decoration: InputDecoration(
                                          hintText: l10n.phoneHint,
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          filled: false,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(l10n.emirateLabel, style: AppTextStyles.label),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 32),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              if (state.status == AuthStatus.error && state.errorMessage != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(state.errorMessage!,
                                      style: AppTextStyles.bodyMuted.copyWith(color: AppColors.error)),
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
                                icon: Icons.arrow_forward_rounded,
                                loading: state.status == AuthStatus.submittingPhone,
                                onPressed:
                                    state.phone.trim().isEmpty ? null : () => context.read<AuthCubit>().sendCode(),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The banner above the docked card — a burgundy-to-blush gradient (a
/// gold arch flourish standing in for real drape photography, matching
/// the rest of the app's placeholder-first approach) carrying the
/// language toggle and the wordmark.
class _AuthHero extends StatelessWidget {
  const _AuthHero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [AppColors.tealDark, AppColors.teal, Color(0xFFF0DFDC), Color(0xFFFBF3EF)],
          stops: [0.0, 0.42, 0.78, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _HeroDecorationPainter())),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: _LanguagePill(label: l10n.switchToEnglish),
                  ),
                  const SizedBox(height: 34),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.appName,
                        style: AppTextStyles.h1
                            .copyWith(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.tealDark),
                      ),
                      const SizedBox(width: 8),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          l10n.appNameLatin,
                          style: AppTextStyles.wordmarkLatin
                              .copyWith(fontSize: 12, letterSpacing: 5, color: AppColors.tealMuted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.authSubtitle,
                    style: AppTextStyles.body.copyWith(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(2)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final String label;

  const _LanguagePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.28),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => context.read<LocaleCubit>().toggle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          // A language switcher reads icon-then-label regardless of the
          // app's current direction — it's picking the *other* language,
          // so it shouldn't mirror with the Arabic content around it.
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language_rounded, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(label, style: AppTextStyles.buttonSecondary.copyWith(color: Colors.white, fontSize: 12.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The hero's decoration, standing in for real drape/embroidery
/// photography: a soft glow lifting the wordmark off the gradient, a
/// nested gold arch (a doorway/mihrab silhouette, cropped by the bottom
/// edge) where a real photo's mannequin would stand, and a small
/// hand-placed scatter of points suggesting embroidered thread — not a
/// random field of noise.
class _HeroDecorationPainter extends CustomPainter {
  static const _sparkle = [
    Offset(0.10, 0.14),
    Offset(0.23, 0.07),
    Offset(0.33, 0.19),
    Offset(0.06, 0.29),
    Offset(0.27, 0.31),
    Offset(0.41, 0.09),
    Offset(0.15, 0.45),
    Offset(0.37, 0.41),
    Offset(0.05, 0.61),
    Offset(0.21, 0.57),
    Offset(0.45, 0.27),
    Offset(0.30, 0.05),
  ];

  Path _arch({
    required double left,
    required double right,
    required Size size,
    required double springFraction,
    required double peakFraction,
  }) {
    final midX = (left + right) / 2;
    final springY = size.height * springFraction;
    final peakY = size.height * peakFraction;
    return Path()
      ..moveTo(left, size.height + 24)
      ..lineTo(left, springY)
      ..quadraticBezierTo(left, peakY, midX, peakY)
      ..quadraticBezierTo(right, peakY, right, springY)
      ..lineTo(right, size.height + 24);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final glowCenter = Offset(size.width * 0.8, size.height * 0.3);
    final glowRadius = size.width * 0.5;
    canvas.drawCircle(
      glowCenter,
      glowRadius,
      Paint()
        ..shader = RadialGradient(colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0)])
            .createShader(Rect.fromCircle(center: glowCenter, radius: glowRadius)),
    );

    canvas.drawPath(
      _arch(left: size.width * 0.06, right: size.width * 0.58, size: size, springFraction: 0.58, peakFraction: 0.04),
      Paint()
        ..color = AppColors.gold.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    canvas.drawPath(
      _arch(left: size.width * 0.15, right: size.width * 0.49, size: size, springFraction: 0.54, peakFraction: 0.13),
      Paint()
        ..color = AppColors.gold.withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final dotPaint = Paint()..color = AppColors.gold.withOpacity(0.5);
    for (var i = 0; i < _sparkle.length; i++) {
      final p = _sparkle[i];
      canvas.drawCircle(Offset(size.width * p.dx, size.height * p.dy), i.isEven ? 1.6 : 1.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
