import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/haptics.dart';
import '../../domain/enums/home_type.dart';
import 'onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  HomeType? _selectedHomeType;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_currentPage < 2) {
      await _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(onboardingControllerProvider.notifier)
          .complete(homeType: _selectedHomeType);
      AppHaptics.success();
      if (!mounted) return;
      context.go('/');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final pages = <_OnboardingPageData>[
      _OnboardingPageData(
        icon: Icons.home_work_outlined,
        title: l10n.onboardingPage1Title,
        body: l10n.onboardingPage1Body,
      ),
      _OnboardingPageData(
        icon: Icons.notifications_active_outlined,
        title: l10n.onboardingPage2Title,
        body: l10n.onboardingPage2Body,
      ),
      _OnboardingPageData(
        icon: Icons.celebration_outlined,
        title: l10n.onboardingPage3Title,
        body: l10n.onboardingPage3Body,
        showHomeTypeSelector: true,
      ),
    ];

    final isLast = _currentPage == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _saving ? null : _finish,
                child: Text(l10n.onboardingSkip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    data: pages[index],
                    selectedHomeType: _selectedHomeType,
                    onHomeTypeSelected: (type) {
                      setState(() => _selectedHomeType = type);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) {
                  final selected = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: selected ? 24 : 8,
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primary
                          : AppColors.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _next,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          isLast ? l10n.onboardingStart : l10n.onboardingNext,
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

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.body,
    this.showHomeTypeSelector = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool showHomeTypeSelector;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.selectedHomeType,
    required this.onHomeTypeSelected,
  });

  final _OnboardingPageData data;
  final HomeType? selectedHomeType;
  final ValueChanged<HomeType> onHomeTypeSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            data.title,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (data.showHomeTypeSelector) ...[
            const SizedBox(height: 32),
            Text(
              l10n.onboardingHomeTypeLabel,
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: HomeType.values.map((type) {
                final selected = selectedHomeType == type;
                return ChoiceChip(
                  label: Text(type.label(l10n)),
                  selected: selected,
                  onSelected: (_) => onHomeTypeSelected(type),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
