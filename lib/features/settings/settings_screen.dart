import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_dimens.dart';
import '../../shared/widgets/status_banner.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../data/repositories/repository_providers.dart';
import '../../data/services/notification_providers.dart';
import '../export/export_controller.dart';
import 'settings_provider.dart';

const _kPrivacyUrlEn =
    'https://darumo92.github.io/housekeep-legal/privacy_en.html';
const _kPrivacyUrlEs =
    'https://darumo92.github.io/housekeep-legal/privacy_es.html';
const _kTermsUrlEn =
    'https://darumo92.github.io/housekeep-legal/terms_en.html';
const _kTermsUrlEs =
    'https://darumo92.github.io/housekeep-legal/terms_es.html';
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _SectionHeader(label: l10n.settingsSectionGeneral),
            _LanguageTile(
              current: settings.localePreference,
              onChanged: (pref) async {
                await ref
                    .read(settingsControllerProvider.notifier)
                    .setLocalePreference(pref);
              },
            ),
            const Divider(height: 1),
            _SectionHeader(label: l10n.settingsSectionNotifications),
            const _NotificationsPermissionBanner(),
            SwitchListTile(
              title: Text(l10n.settingsNotificationsEnabled),
              subtitle: Text(l10n.settingsNotificationsEnabledBody),
              value: settings.notificationsEnabled,
              onChanged: (value) async {
                await ref
                    .read(settingsControllerProvider.notifier)
                    .setNotificationsEnabled(value);
              },
            ),
            ListTile(
              title: Text(l10n.settingsNotificationsOpenSystem),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () async {
                await AppSettings.openAppSettings(
                  type: AppSettingsType.notification,
                );
              },
            ),
            const Divider(height: 1),
            _SectionHeader(label: l10n.settingsSectionPremium),
            _PremiumTile(isProAsync: isProAsync),
            ListTile(
              title: Text(l10n.settingsPremiumRestore),
              trailing: const Icon(Icons.refresh, size: 20),
              onTap: () => _restorePurchases(context, ref),
            ),
            if (AppConstants.betaShowProToggle)
              SwitchListTile(
                title: const Text('BETA: Simular PRO'),
                subtitle: const Text('Solo para testers — desaparece en lanzamiento'),
                value: isProAsync.valueOrNull ?? false,
                onChanged: (value) {
                  ref
                      .read(proDebugOverrideProvider.notifier)
                      .set(value);
                },
              ),
            const Divider(height: 1),
            _SectionHeader(label: l10n.settingsSectionWidget),
            _WidgetTile(isProAsync: isProAsync),
            const Divider(height: 1),
            _SectionHeader(label: l10n.settingsSectionData),
            _ExportPdfTile(isProAsync: isProAsync),
            const Divider(height: 1),
            _SectionHeader(label: l10n.settingsSectionAbout),
            const _VersionTile(),
            ListTile(
              title: Text(l10n.settingsAboutContact),
              trailing: const Icon(Icons.mail_outline, size: 20),
              onTap: () => _launchMail(context, _kSupportEmail),
            ),
            ListTile(
              title: Text(l10n.settingsAboutFeedback),
              trailing: const Icon(Icons.feedback_outlined, size: 20),
              onTap: () => _launchMail(context, _kFeedbackEmail),
            ),
            ListTile(
              title: Text(l10n.settingsAboutPrivacy),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => _launchUrl(
                context,
                _localizedPrivacyUrl(context),
              ),
            ),
            ListTile(
              title: Text(l10n.settingsAboutTerms),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => _launchUrl(
                context,
                _localizedTermsUrl(context),
              ),
            ),
            ListTile(
              title: Text(l10n.settingsAboutRate),
              trailing: const Icon(Icons.star_border, size: 22),
              onTap: () async {
                final url = Theme.of(context).platform == TargetPlatform.iOS
                    ? _kStoreUrlIos
                    : _kStoreUrlAndroid;
                await _launchUrl(context, url);
              },
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Future<void> _restorePurchases(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await ref
          .read(purchaseRepositoryProvider)
          .restorePurchases();
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.current, required this.onChanged});

  final LocalePreference current;
  final ValueChanged<LocalePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String labelFor(LocalePreference p) {
      return switch (p) {
        LocalePreference.system => l10n.settingsLanguageSystem,
        LocalePreference.es => l10n.settingsLanguageEs,
        LocalePreference.en => l10n.settingsLanguageEn,
      };
    }

    return ListTile(
      title: Text(l10n.settingsLanguageLabel),
      subtitle: Text(labelFor(current)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final picked = await showModalBottomSheet<LocalePreference>(
          context: context,
          builder: (context) {
            return SafeArea(
              child: RadioGroup<LocalePreference>(
                groupValue: current,
                onChanged: (val) => Navigator.of(context).pop(val),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: LocalePreference.values.map((p) {
                    return RadioListTile<LocalePreference>(
                      title: Text(labelFor(p)),
                      value: p,
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

class _PremiumTile extends StatelessWidget {
  const _PremiumTile({required this.isProAsync});

  final AsyncValue<bool> isProAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPro = isProAsync.maybeWhen(data: (v) => v, orElse: () => false);

    return ListTile(
      leading: Icon(
        isPro ? Icons.workspace_premium : Icons.lock_outline,
        color: isPro ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        isPro ? l10n.settingsPremiumStatusPro : l10n.settingsPremiumStatusFree,
      ),
      subtitle: isPro ? null : Text(l10n.settingsPremiumUpgrade),
      trailing: isPro
          ? null
          : FilledButton.tonal(
              onPressed: () => context.push('/paywall'),
              child: Text(l10n.settingsPremiumUpgrade),
            ),
      onTap: isPro ? null : () => context.push('/paywall'),
    );
  }
}

class _VersionTile extends StatefulWidget {
  const _VersionTile();

  @override
  State<_VersionTile> createState() => _VersionTileState();
}

class _VersionTileState extends State<_VersionTile> {
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
    return ListTile(
      title: Text(l10n.settingsAboutVersion(_version ?? '…')),
      leading: const Icon(Icons.info_outline),
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

class _WidgetTile extends StatelessWidget {
  const _WidgetTile({required this.isProAsync});

  final AsyncValue<bool> isProAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPro = isProAsync.maybeWhen(data: (v) => v, orElse: () => false);
    return ListTile(
      leading: const Icon(Icons.widgets_outlined),
      title: Text(l10n.settingsWidgetTitle),
      subtitle: Text(
        isPro ? l10n.settingsWidgetBodyPro : l10n.settingsWidgetBodyFree,
      ),
      trailing: TextButton(
        onPressed: () {
          if (!isPro) {
            context.push('/paywall');
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
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(l10n.settingsWidgetHowToClose),
                  ),
                ],
              );
            },
          );
        },
        child: Text(
          isPro ? l10n.settingsWidgetCta : l10n.settingsWidgetUpgrade,
        ),
      ),
    );
  }
}

class _ExportPdfTile extends ConsumerStatefulWidget {
  const _ExportPdfTile({required this.isProAsync});

  final AsyncValue<bool> isProAsync;

  @override
  ConsumerState<_ExportPdfTile> createState() => _ExportPdfTileState();
}

class _ExportPdfTileState extends ConsumerState<_ExportPdfTile> {
  bool _busy = false;

  Future<void> _onPressed() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final isPro =
        widget.isProAsync.maybeWhen(data: (v) => v, orElse: () => false);
    if (!isPro) {
      context.push('/paywall');
      return;
    }
    if (_busy) return;
    setState(() => _busy = true);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.settingsDataExportProgress)),
    );
    try {
      final localeTag = Localizations.localeOf(context).toLanguageTag();
      final ok = await ref
          .read(exportControllerProvider)
          .exportAndShare(l10n, localeTag: localeTag);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            ok ? l10n.settingsDataExportSuccess : l10n.settingsDataExportEmpty,
          ),
        ),
      );
    } catch (_) {
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
    final isPro =
        widget.isProAsync.maybeWhen(data: (v) => v, orElse: () => false);
    return ListTile(
      leading: const Icon(Icons.picture_as_pdf_outlined),
      title: Text(l10n.settingsDataExportTitle),
      subtitle: Text(
        isPro
            ? l10n.settingsDataExportBodyPro
            : l10n.settingsDataExportBodyFree,
      ),
      trailing: _busy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : TextButton(
              onPressed: _onPressed,
              child: Text(
                isPro
                    ? l10n.settingsDataExportCta
                    : l10n.settingsDataExportUpgrade,
              ),
            ),
    );
  }
}

class _NotificationsPermissionBanner extends ConsumerStatefulWidget {
  const _NotificationsPermissionBanner();

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
    final granted = grantedAsync.maybeWhen(
      data: (v) => v,
      orElse: () => true,
    );
    if (granted) return const SizedBox.shrink();

    return StatusBanner(
      variant: StatusBannerVariant.warning,
      icon: Icons.notifications_off_outlined,
      title: l10n.settingsNotificationsDeniedTitle,
      body: l10n.settingsNotificationsDeniedBody,
      margin: const EdgeInsets.fromLTRB(
        Spacing.l,
        Spacing.xs,
        Spacing.l,
        Spacing.s,
      ),
      action: FilledButton.tonal(
        onPressed: () async {
          await AppSettings.openAppSettings(
            type: AppSettingsType.notification,
          );
        },
        child: Text(l10n.settingsNotificationsDeniedCta),
      ),
    );
  }
}
