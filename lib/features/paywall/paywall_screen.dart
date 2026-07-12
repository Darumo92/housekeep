import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../shared/widgets/hk_button.dart';
import 'paywall_provider.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key, this.gate = false});

  final bool gate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final offeringAsync = ref.watch(currentOfferingProvider);
    final controllerState = ref.watch(purchaseControllerProvider);

    ref.listen<PurchaseControllerState>(purchaseControllerProvider, (
      previous,
      next,
    ) {
      if (next.isCancelled) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.paywallCancelled)));
        ref.read(purchaseControllerProvider.notifier).reset();
      } else if (next.isError && previous?.isError != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? l10n.paywallPurchaseError),
          ),
        );
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: context.hkc.bg,
        body: offeringAsync.when(
          data: (offering) => _PaywallBody(
            offering: offering,
            controllerState: controllerState,
            gate: gate,
          ),
          loading: () => const SafeArea(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => _PaywallBody(
            offering: null,
            controllerState: controllerState,
            gate: gate,
            errorOverride: error.toString(),
          ),
        ),
      ),
    );
  }
}

class _PaywallBody extends ConsumerWidget {
  const _PaywallBody({
    required this.offering,
    required this.controllerState,
    required this.gate,
    this.errorOverride,
  });

  final PurchaseOffering? offering;
  final PurchaseControllerState controllerState;
  final bool gate;
  final String? errorOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    if (controllerState.isSuccess) {
      return SafeArea(
        child: _SuccessView(
          onContinue: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      );
    }

    final package = offering?.primaryPackage;
    final priceString = package?.priceString ?? '4,99 €';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroBand(
                  gate: gate,
                  priceString: priceString,
                  onBack: () =>
                      context.canPop() ? context.pop() : context.go('/'),
                ),
                _BenefitsList(),
                if (errorOverride != null || package == null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
                    child: _UnavailableNotice(message: errorOverride),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        _StickyCtaBar(
          loading: controllerState.isLoading,
          enabled: package != null && !controllerState.isLoading,
          onPurchase: () {
            if (package == null) return;
            HapticFeedback.lightImpact();
            ref.read(purchaseControllerProvider.notifier).buy(package);
          },
          onRestore: controllerState.isLoading
              ? null
              : () => ref.read(purchaseControllerProvider.notifier).restore(),
          onSkip: () => context.canPop() ? context.pop() : context.go('/'),
          ctaLabel: l10n.paywallUnlockCta,
          restoreLabel: l10n.paywallRestore,
          skipLabel: l10n.paywallSkip,
        ),
      ],
    );
  }
}

class _HeroBand extends StatelessWidget {
  const _HeroBand({
    required this.gate,
    required this.priceString,
    required this.onBack,
  });

  final bool gate;
  final String priceString;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22, topPadding + 12, 22, 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, -1),
          end: const Alignment(0.3, 1),
          colors: [context.hkc.primary, context.hkc.primary, context.hkc.accent],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CircleIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  'PRO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Colors.white,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (gate) ...[
            _GateBanner(
              title: l10n.paywallGateTitle,
              body: l10n.paywallGateSub,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            l10n.paywallHeroTitle,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 1.05,
              color: Colors.white,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paywallSubtitle,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.85),
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                priceString,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '· ${l10n.paywallOnce}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _GateBanner extends StatelessWidget {
  const _GateBanner({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadii.btn),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final benefits = <(IconData, String)>[
      (Icons.inventory_2_rounded, l10n.paywallBenefitUnlimited),
      (Icons.notifications_rounded, l10n.paywallBenefitMultiReminder),
      (Icons.auto_awesome_rounded, l10n.paywallBenefitWidget),
      (Icons.share_rounded, l10n.paywallBenefitPdf),
      (Icons.local_florist_rounded, l10n.paywallBenefitTemplates),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
      child: Column(
        children: [
          for (final (icon, text) in benefits)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: context.hkc.primarySoft,
                      borderRadius: BorderRadius.circular(AppRadii.card * 0.45),
                    ),
                    child: Icon(icon, size: 18, color: context.hkc.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          color: context.hkc.text,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: context.hkc.ok,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StickyCtaBar extends StatelessWidget {
  const _StickyCtaBar({
    required this.loading,
    required this.enabled,
    required this.onPurchase,
    required this.onRestore,
    required this.onSkip,
    required this.ctaLabel,
    required this.restoreLabel,
    required this.skipLabel,
  });

  final bool loading;
  final bool enabled;
  final VoidCallback onPurchase;
  final VoidCallback? onRestore;
  final VoidCallback onSkip;
  final String ctaLabel;
  final String restoreLabel;
  final String skipLabel;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(22, 14, 22, 22 + bottomPad),
      decoration: BoxDecoration(
        color: context.hkc.bg,
        border: Border(top: BorderSide(color: context.hkc.border, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: loading
                ? _LoadingCtaButton()
                : HkButton(
                    icon: Icons.auto_awesome_rounded,
                    label: ctaLabel,
                    variant: HkButtonVariant.primary,
                    size: HkButtonSize.lg,
                    full: true,
                    onPressed: enabled ? onPurchase : null,
                  ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextButton(
                    onPressed: onRestore,
                    style: TextButton.styleFrom(
                      foregroundColor: context.hkc.textMuted,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      restoreLabel,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: context.hkc.textMuted,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      skipLabel,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCtaButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: context.hkc.primary,
        borderRadius: BorderRadius.circular(AppRadii.btn),
      ),
      alignment: Alignment.center,
      child: const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}

class _UnavailableNotice extends StatelessWidget {
  const _UnavailableNotice({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.hkc.dangerSoft,
        borderRadius: BorderRadius.circular(AppRadii.btn),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.paywallOfferingUnavailable,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.hkc.danger,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 6),
            Text(
              message!,
              style: TextStyle(
                fontSize: 12,
                color: context.hkc.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: context.hkc.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 56,
              color: context.hkc.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.paywallSuccessTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: context.hkc.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.paywallSuccessBody,
            style: TextStyle(
              fontSize: 15,
              color: context.hkc.textMuted,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          HkButton(
            label: l10n.paywallSuccessContinue,
            variant: HkButtonVariant.primary,
            size: HkButtonSize.lg,
            full: true,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
