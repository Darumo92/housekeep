import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../shared/widgets/hk_button.dart';
import '../../shared/widgets/hk_card.dart';
import '../../shared/widgets/hk_toggle.dart';
import '../../shared/widgets/status_banner.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/analytics_providers.dart';
import '../../data/services/demo_seed_service.dart';
import '../../data/services/notification_providers.dart';
import '../../data/services/notification_strings.dart';
import '../export/export_controller.dart';
import 'settings_provider.dart';

const _kPrivacyUrlEn =
    'https://darumo92.github.io/housekeep-legal/privacy_en.html';
const _kPrivacyUrlEs =
    'https://darumo92.github.io/housekeep-legal/privacy_es.html';
const _kTermsUrlEn = 'https://darumo92.github.io/housekeep-legal/terms_en.html';
const _kTermsUrlEs = 'https://darumo92.github.io/housekeep-legal/terms_es.html';
const _kSupportEmail = 'darumo092@gmail.com';
const _kFeedbackEmail = 'darumo092@gmail.com';
const _kStoreUrlAndroid =
    'https://play.google.com/store/apps/details?id=com.housekeep.app';
const _kStoreUrlIos = 'https://apps.apple.com/app/housekeep/id000000000';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(settingsControllerProvider);
    final isProAsync = ref.watch(isProProvider);
    final isPro = isProAsync.maybeWhen(data: (v) => v, orElse: () => false);

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(error.toString()),
        ),
      ),
      data: (settings) {
        return ListView(
          padding: EdgeInsets.fromLTRB(
            22,
            MediaQuery.of(context).padding.top + 8,
            22,
            100,
          ),
          children: [
            Text(
              l10n.settingsTitle,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: context.hkc.text,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
            const SizedBox(height: 20),
            _PlanCard(isPro: isPro),
            const SizedBox(height: 12),
            _NotificationsPermissionBanner(),
            _Section(label: l10n.settingsSectionNotifications),
            HkCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.notifications_rounded,
                    label: l10n.settingsNotificationsEnabled,
                    trailing: HkToggle(
                      value: settings.notificationsEnabled,
                      onChanged: (value) async {
                      await ref
                          .read(settingsControllerProvider.notifier)
                          .setNotificationsEnabled(
                            value,
                            texts: NotificationTexts.fromL10n(l10n),
                          );
                      ref.read(analyticsServiceProvider).settingsNotificationsToggled(value);
                      },
                    ),
                  ),
                  const _RowDivider(),
                  _SettingsRow(
                    icon: Icons.tune_rounded,
                    label: l10n.settingsNotificationsOpenSystem,
                    chevron: true,
                    onTap: () async {
                      await AppSettings.openAppSettings(
                        type: AppSettingsType.notification,
                      );
                    },
                  ),
                ],
              ),
            ),
            _Section(label: l10n.settingsSectionPreferences),
            HkCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.language_rounded,
                    label: l10n.settingsLanguageLabel,
                    trailing: _LanguagePillSwitcher(
                      current: settings.localePreference,
                      onChanged: (pref) async {
                        await ref
                            .read(settingsControllerProvider.notifier)
                            .setLocalePreference(pref);
                        ref.read(analyticsServiceProvider).settingsLanguageChanged(pref.name);
                      },
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.brightness_6_rounded,
                    label: l10n.settingsThemeLabel,
                    trailing: _ThemePillSwitcher(
                      current: settings.themePreference,
                      onChanged: (pref) async {
                        await ref
                            .read(settingsControllerProvider.notifier)
                            .setThemePreference(pref);
                        ref.read(analyticsServiceProvider).settingsThemeChanged(pref.name);
                      },
                    ),
                  ),
                ],
              ),
            ),
            _Section(label: l10n.settingsSectionPremium),
            HkCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.widgets_rounded,
                    label: l10n.settingsWidgetTitle,
                    trailing: _ProActionLabel(
                      isPro: isPro,
                      activeLabel: l10n.settingsWidgetCta,
                      lockedLabel: l10n.settingsWidgetUpgrade,
                    ),
                    onTap: () {
                      if (!isPro) {
                        context.push('/paywall?gate=true');
                        return;
                      }
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: Text(l10n.settingsWidgetHowToTitle),
                            content: Text(l10n.settingsWidgetHowToBody),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                child: Text(l10n.settingsWidgetHowToClose),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const _RowDivider(),
                  _ExportPdfRow(isPro: isPro),
                  const _RowDivider(),
                  _SettingsRow(
                    icon: Icons.refresh_rounded,
                    label: l10n.settingsPremiumRestore,
                    chevron: true,
                    onTap: () => _restorePurchases(context, ref),
                  ),
                  if (kDebugMode || AppConstants.betaShowProToggle) ...[
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.science_rounded,
                      label: 'BETA: Simular PRO',
                      trailing: HkToggle(
                        value: isPro,
                        onChanged: (value) async {
                          await ref
                              .read(proDebugOverrideProvider.notifier)
                              .set(value);
                        },
                      ),
                    ),
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.notifications_active_rounded,
                      label: 'BETA: Probar notificación (+10s)',
                      chevron: true,
                      onTap: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final ok = await ref
                            .read(notificationServiceProvider)
                            .scheduleTestNotification(
                              title: l10n.notificationDocumentTitle,
                              body: 'Test HouseKeep ✓',
                            );
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              ok
                                  ? 'Notificación programada en 10s'
                                  : 'No se pudo (¿sin permiso o init?)',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            if (kDebugMode) ...[
              const _Section(label: 'DEBUG: Datos demo (screenshots)'),
              HkCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: Icons.auto_fix_high_rounded,
                      label: 'Cargar datos demo (idioma actual)',
                      chevron: true,
                      onTap: () => _seedDemoData(context, ref),
                    ),
                    const _RowDivider(),
                    _SettingsRow(
                      icon: Icons.delete_sweep_rounded,
                      label: 'Borrar datos demo',
                      chevron: true,
                      onTap: () => _clearDemoData(context, ref),
                    ),
                  ],
                ),
              ),
            ],
            _Section(label: l10n.settingsSectionAbout),
            HkCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  const _VersionRow(),
                  const _RowDivider(),
                  _SettingsRow(
                    icon: Icons.mail_outline_rounded,
                    label: l10n.settingsAboutContact,
                    chevron: true,
                    onTap: () => _launchMail(context, _kSupportEmail),
                  ),
                  const _RowDivider(),
                  _SettingsRow(
                    icon: Icons.feedback_outlined,
                    label: l10n.settingsAboutFeedback,
                    chevron: true,
                    onTap: () => _launchMail(context, _kFeedbackEmail),
                  ),
                  const _RowDivider(),
                  _SettingsRow(
                    icon: Icons.lock_outline_rounded,
                    label: l10n.settingsAboutPrivacy,
                    chevron: true,
                    onTap: () =>
                        _launchUrl(context, _localizedPrivacyUrl(context)),
                  ),
                  const _RowDivider(),
                  _SettingsRow(
                    icon: Icons.description_outlined,
                    label: l10n.settingsAboutTerms,
                    chevron: true,
                    onTap: () =>
                        _launchUrl(context, _localizedTermsUrl(context)),
                  ),
                  const _RowDivider(),
                  _SettingsRow(
                    icon: Icons.star_border_rounded,
                    label: l10n.settingsAboutRate,
                    chevron: true,
                    onTap: () async {
                      final url =
                          Theme.of(context).platform == TargetPlatform.iOS
                          ? _kStoreUrlIos
                          : _kStoreUrlAndroid;
                      await _launchUrl(context, url);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Center(
              child: Text(
                l10n.settingsFooter,
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.8,
                  color: context.hkc.textFaint,
                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _restorePurchases(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      ref.read(analyticsServiceProvider).paywallRestoreStarted();
      final result = await ref
          .read(purchaseRepositoryProvider)
          .restorePurchases();
      if (result.status == PurchaseStatus.success) {
        // Force every isPro watcher to re-read the repository's current value
        // so the UI cannot get stuck on a stale Free state after a restore.
        ref.invalidate(isProProvider);
        ref.read(analyticsServiceProvider).paywallRestoreSuccess();
      }
      final message = result.status == PurchaseStatus.success
          ? l10n.settingsPremiumRestoreSuccess
          : l10n.settingsPremiumRestoreNone;
      messenger.showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsPremiumRestoreFailed)),
      );
    }
  }

  Future<void> _seedDemoData(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final service = DemoSeedService(
      items: ref.read(itemsRepositoryProvider),
      maintenances: ref.read(maintenancesRepositoryProvider),
      documents: ref.read(documentsRepositoryProvider),
    );
    try {
      await service.seed(DemoSeedStrings.forLanguageCode(languageCode));
      messenger.showSnackBar(
        SnackBar(content: Text('Datos demo cargados ($languageCode)')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _clearDemoData(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final service = DemoSeedService(
      items: ref.read(itemsRepositoryProvider),
      maintenances: ref.read(maintenancesRepositoryProvider),
      documents: ref.read(documentsRepositoryProvider),
    );
    try {
      await service.clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Datos demo borrados')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsLinkOpenFailed)),
      );
    }
  }

  Future<void> _launchMail(BuildContext context, String address) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri(scheme: 'mailto', path: address);
    final ok = await launchUrl(uri);
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsLinkOpenFailed)),
      );
    }
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.isPro});

  final bool isPro;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (isPro) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.hkc.primary, context.hkc.accent],
          ),
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(AppRadii.card * 0.5),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsPremiumStatusPro,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.settingsPlanProSub,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                l10n.settingsProActive,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return HkCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.hkc.primarySoft,
              borderRadius: BorderRadius.circular(AppRadii.card * 0.5),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: context.hkc.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsPremiumStatusFree,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.hkc.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.settingsPlanFreeSub,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.hkc.textMuted,
                  ),
                ),
              ],
            ),
          ),
          HkButton(
            label: l10n.settingsPremiumUpgrade,
            variant: HkButtonVariant.accent,
            size: HkButtonSize.sm,
            onPressed: () => context.push('/paywall'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 22, 4, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: context.hkc.textMuted,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.chevron = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final bool chevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.hkc.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: context.hkc.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: context.hkc.text,
              ),
            ),
          ),
          if (trailing != null) trailing!,
          if (chevron) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: context.hkc.textFaint,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return InkWell(onTap: onTap, child: row);
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 58),
      child: Divider(height: 1, thickness: 1, color: context.hkc.border),
    );
  }
}

class _LanguagePillSwitcher extends StatelessWidget {
  const _LanguagePillSwitcher({required this.current, required this.onChanged});

  final LocalePreference current;
  final ValueChanged<LocalePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = <(LocalePreference, String)>[
      (LocalePreference.system, 'SYS'),
      (LocalePreference.es, 'ES'),
      (LocalePreference.en, 'EN'),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.hkc.surfaceAlt,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: context.hkc.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (pref, label) in options)
            GestureDetector(
              onTap: () => onChanged(pref),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: current == pref
                      ? context.hkc.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: current == pref
                        ? context.hkc.onPrimary
                        : context.hkc.textMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThemePillSwitcher extends StatelessWidget {
  const _ThemePillSwitcher({required this.current, required this.onChanged});

  final ThemePreference current;
  final ValueChanged<ThemePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = <(ThemePreference, IconData, String)>[
      (ThemePreference.system, Icons.brightness_auto_rounded, l10n.settingsThemeSystem),
      (ThemePreference.light, Icons.light_mode_rounded, l10n.settingsThemeLight),
      (ThemePreference.dark, Icons.dark_mode_rounded, l10n.settingsThemeDark),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.hkc.surfaceAlt,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: context.hkc.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (pref, icon, tooltip) in options)
            Tooltip(
              message: tooltip,
              child: GestureDetector(
                onTap: () => onChanged(pref),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: current == pref
                        ? context.hkc.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: current == pref
                        ? context.hkc.onPrimary
                        : context.hkc.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProActionLabel extends StatelessWidget {
  const _ProActionLabel({
    required this.isPro,
    required this.activeLabel,
    required this.lockedLabel,
  });

  final bool isPro;
  final String activeLabel;
  final String lockedLabel;

  @override
  Widget build(BuildContext context) {
    return Text(
      isPro ? activeLabel : lockedLabel,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isPro ? context.hkc.primary : context.hkc.accent,
      ),
    );
  }
}

class _ExportPdfRow extends ConsumerStatefulWidget {
  const _ExportPdfRow({required this.isPro});

  final bool isPro;

  @override
  ConsumerState<_ExportPdfRow> createState() => _ExportPdfRowState();
}

class _ExportPdfRowState extends ConsumerState<_ExportPdfRow> {
  bool _busy = false;

  Future<void> _onTap() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!widget.isPro) {
      context.push('/paywall?gate=true');
      return;
    }
    if (_busy) return;
    setState(() => _busy = true);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.settingsDataExportProgress)),
    );
    try {
      ref.read(analyticsServiceProvider).exportPdfStarted();
      final localeTag = Localizations.localeOf(context).toLanguageTag();
      final ok = await ref
          .read(exportControllerProvider)
          .exportAndShare(l10n, localeTag: localeTag);
      if (ok) {
        ref.read(analyticsServiceProvider).exportPdfSuccess();
      } else {
        ref.read(analyticsServiceProvider).exportPdfEmpty();
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            ok ? l10n.settingsDataExportSuccess : l10n.settingsDataExportEmpty,
          ),
        ),
      );
    } catch (_) {
      ref.read(analyticsServiceProvider).exportPdfFailed();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsDataExportFailed)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final trailing = _busy
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : _ProActionLabel(
            isPro: widget.isPro,
            activeLabel: l10n.settingsDataExportCta,
            lockedLabel: l10n.settingsDataExportUpgrade,
          );
    return _SettingsRow(
      icon: Icons.picture_as_pdf_outlined,
      label: l10n.settingsDataExportTitle,
      trailing: trailing,
      onTap: _onTap,
    );
  }
}

class _VersionRow extends StatefulWidget {
  const _VersionRow();

  @override
  State<_VersionRow> createState() => _VersionRowState();
}

class _VersionRowState extends State<_VersionRow> {
  String? _version;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _version = '${info.version}+${info.buildNumber}');
    } catch (_) {
      if (!mounted) return;
      setState(() => _version = '—');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SettingsRow(
      icon: Icons.info_outline_rounded,
      label: l10n.settingsAboutVersion(_version ?? '…'),
      trailing: Text(
        _version ?? '…',
        style: TextStyle(
          fontSize: 12,
          color: context.hkc.textFaint,
          fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
        ),
      ),
    );
  }
}

String _localizedPrivacyUrl(BuildContext context) {
  return Localizations.localeOf(context).languageCode == 'es'
      ? _kPrivacyUrlEs
      : _kPrivacyUrlEn;
}

String _localizedTermsUrl(BuildContext context) {
  return Localizations.localeOf(context).languageCode == 'es'
      ? _kTermsUrlEs
      : _kTermsUrlEn;
}

class _NotificationsPermissionBanner extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NotificationsPermissionBanner> createState() =>
      _NotificationsPermissionBannerState();
}

class _NotificationsPermissionBannerState
    extends ConsumerState<_NotificationsPermissionBanner>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(notificationsGrantedProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final grantedAsync = ref.watch(notificationsGrantedProvider);
    final granted = grantedAsync.maybeWhen(data: (v) => v, orElse: () => true);
    if (granted) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: StatusBanner(
        variant: StatusBannerVariant.warning,
        icon: Icons.notifications_off_outlined,
        title: l10n.settingsNotificationsDeniedTitle,
        body: l10n.settingsNotificationsDeniedBody,
        margin: EdgeInsets.zero,
        action: HkButton(
          label: l10n.settingsNotificationsDeniedCta,
          variant: HkButtonVariant.soft,
          size: HkButtonSize.sm,
          onPressed: () async {
            await AppSettings.openAppSettings(
              type: AppSettingsType.notification,
            );
          },
        ),
      ),
    );
  }
}
