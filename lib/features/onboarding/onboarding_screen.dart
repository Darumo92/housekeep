import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/utils/haptics.dart';
import '../../data/services/analytics_providers.dart';
import '../../shared/widgets/hk_button.dart';
import 'onboarding_provider.dart';
import 'widgets/onboarding_art.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentPage = 0;
  bool _saving = false;
  bool _completing = false;
  late final AnimationController _completionController;

  static const _pageCount = 3;

  @override
  void initState() {
    super.initState();
    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _completionController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_currentPage < _pageCount - 1) {
      await _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
      return;
    }
    await _finish();
  }

  Future<void> _back() async {
    if (_currentPage == 0) return;
    await _controller.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(onboardingControllerProvider.notifier).complete();
      ref.read(analyticsServiceProvider).onboardingCompleted();
      AppHaptics.success();
      if (!mounted) return;
      setState(() => _completing = true);
      _completionController.forward();
      await Future<void>.delayed(const Duration(milliseconds: 650));
      if (!mounted) return;
      context.go('/');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = <_OnboardingPageData>[
      _OnboardingPageData(
        title: l10n.onboardingPage1Title,
        body: l10n.onboardingPage1Body,
        art: const OnboardingArtHomeCluster(),
      ),
      _OnboardingPageData(
        title: l10n.onboardingPage2Title,
        body: l10n.onboardingPage2Body,
        art: const OnboardingArtBellStack(),
      ),
      _OnboardingPageData(
        title: l10n.onboardingPage3Title,
        body: l10n.onboardingPage3Body,
        art: const OnboardingArtSparkleItem(),
      ),
    ];

    return Scaffold(
      backgroundColor: context.hkc.bg,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              opacity: _completing ? 0 : 1,
              child: _buildBody(l10n, pages),
            ),
            if (_completing)
              Positioned.fill(
                child: _CompletionOverlay(controller: _completionController),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, List<_OnboardingPageData> pages) {
    final isLast = _currentPage == _pageCount - 1;
    final showSkip = !isLast;
    final showBack = _currentPage > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        children: [
          SizedBox(
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (showSkip)
                  TextButton(
                    onPressed: _saving
                        ? null
                        : () {
                            ref.read(
                              analyticsServiceProvider,
                            ).onboardingSkipped();
                            _finish();
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: context.hkc.textMuted,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      l10n.onboardingSkip,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.hkc.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) =>
                  _OnboardingPage(data: pages[index]),
            ),
          ),
          const SizedBox(height: 12),
          _Dots(current: _currentPage, count: _pageCount),
          const SizedBox(height: 20),
          Row(
            children: [
              if (showBack) ...[
                HkButton(
                  label: '',
                  icon: Symbols.arrow_back_rounded,
                  variant: HkButtonVariant.outline,
                  size: HkButtonSize.lg,
                  onPressed: _saving ? null : _back,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: _saving
                    ? const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        ),
                      )
                    : HkButton(
                        label: isLast
                            ? l10n.onboardingStart
                            : l10n.onboardingNext,
                        icon: isLast
                            ? Symbols.auto_awesome_rounded
                            : Symbols.arrow_forward_rounded,
                        size: HkButtonSize.lg,
                        full: true,
                        onPressed: _saving ? null : _next,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.body,
    required this.art,
  });

  final String title;
  final String body;
  final Widget art;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: data.art),
          const SizedBox(height: 28),
          Text(
            data.title,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.hkc.text,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              height: 1.5,
              color: context.hkc.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.current, required this.count});

  final int current;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            width: i == current ? 24 : 6,
            decoration: BoxDecoration(
              color: i == current ? context.hkc.primary : context.hkc.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

class _CompletionOverlay extends StatelessWidget {
  const _CompletionOverlay({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final scale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.6, curve: Curves.elasticOut),
      ),
    );
    final fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.35, curve: Curves.easeOut),
      ),
    );
    return Container(
      color: context.hkc.bg,
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              color: context.hkc.primarySoft,
              borderRadius: BorderRadius.circular(AppRadii.card * 2),
            ),
            child: Icon(
              Symbols.check_circle_rounded,
              size: 96,
              color: context.hkc.primary,
              fill: 1,
            ),
          ),
        ),
      ),
    );
  }
}
