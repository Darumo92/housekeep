import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/date_calculations.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../data/services/notification_providers.dart';
import '../../../data/services/notification_strings.dart';
import '../../../domain/models/item.dart';
import '../../../domain/models/maintenance.dart';
import '../../../shared/widgets/hk_button.dart';

enum MarkDoneWhen { today, yesterday, other }

class MarkDoneSheet extends ConsumerStatefulWidget {
  const MarkDoneSheet({
    super.key,
    required this.maintenance,
    required this.item,
    this.now = DateTime.now,
  });

  final Maintenance maintenance;
  final Item item;
  final DateTime Function() now;

  @override
  ConsumerState<MarkDoneSheet> createState() => _MarkDoneSheetState();
}

class _MarkDoneSheetState extends ConsumerState<MarkDoneSheet> {
  MarkDoneWhen _when = MarkDoneWhen.today;
  DateTime? _otherDate;
  bool _isSubmitting = false;
  bool _isComplete = false;

  DateTime get _completedAt {
    final today = _dateOnly(widget.now());
    return switch (_when) {
      MarkDoneWhen.today => today,
      MarkDoneWhen.yesterday => today.subtract(const Duration(days: 1)),
      MarkDoneWhen.other => _otherDate ?? today,
    };
  }

  DateTime get _nextDueAt => DateCalculations.addMonths(
    _completedAt,
    widget.maintenance.intervalMonths,
  );

  int get _daysUntilNextReminder =>
      DateCalculations.calendarDaysUntil(_nextDueAt, _completedAt);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 26),
          child: _isComplete
              ? _SuccessView(days: _daysUntilNextReminder)
              : _form(),
        ),
      ),
    );
  }

  Widget _form() {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppRadii.chip),
            ),
          ),
        ),
        Text(
          l10n.maintenanceMarkDoneSheetTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.text,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.maintenance.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.maintenanceMarkDoneWhenLabel.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _WhenButton(
                label: l10n.maintenanceMarkDoneToday,
                selected: _when == MarkDoneWhen.today,
                onPressed: _isSubmitting
                    ? null
                    : () => _selectWhen(MarkDoneWhen.today),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _WhenButton(
                label: l10n.maintenanceMarkDoneYesterday,
                selected: _when == MarkDoneWhen.yesterday,
                onPressed: _isSubmitting
                    ? null
                    : () => _selectWhen(MarkDoneWhen.yesterday),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _WhenButton(
                label: l10n.maintenanceMarkDoneOtherDate,
                selected: _when == MarkDoneWhen.other,
                onPressed: _isSubmitting
                    ? null
                    : () => _selectWhen(MarkDoneWhen.other),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(AppRadii.btn),
          ),
          child: Row(
            children: [
              const Icon(
                Symbols.notifications_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${l10n.maintenanceMarkDoneNextReminder}: ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: l10n.maintenanceMarkDoneNextInMonths(
                          widget.maintenance.intervalMonths,
                        ),
                      ),
                    ],
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        HkButton(
          label: l10n.maintenanceMarkDoneConfirm,
          icon: Symbols.check_rounded,
          variant: HkButtonVariant.primary,
          size: HkButtonSize.lg,
          full: true,
          onPressed: _isSubmitting ? null : _confirm,
        ),
      ],
    );
  }

  Future<void> _selectWhen(MarkDoneWhen option) async {
    if (option != MarkDoneWhen.other) {
      setState(() => _when = option);
      return;
    }

    final today = _dateOnly(widget.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _otherDate ?? today,
      firstDate: DateTime(2000),
      lastDate: today,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _when = option;
      _otherDate = _dateOnly(picked);
    });
  }

  Future<void> _confirm() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final texts = NotificationTexts.fromL10n(l10n);
    final completedAt = _completedAt;
    AppHaptics.destructive();
    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(maintenancesRepositoryProvider);
      await repository.markAsDone(widget.maintenance.id, doneAt: completedAt);
      final updated = await repository.getMaintenance(widget.maintenance.id);
      if (updated != null) {
        final isPro = ref.read(isProProvider).valueOrNull ?? false;
        await ref
            .read(notificationSchedulerProvider)
            .rescheduleMaintenance(
              maintenance: updated,
              item: widget.item,
              isPro: isPro,
              texts: texts,
            );
      }
      if (!mounted) return;
      setState(() => _isComplete = true);
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      AppHaptics.error();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.maintenanceMarkDoneFailed)),
      );
    }
  }
}

class _WhenButton extends StatelessWidget {
  const _WhenButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return HkButton(
      label: label,
      variant: selected ? HkButtonVariant.primary : HkButtonVariant.outline,
      size: HkButtonSize.sm,
      full: true,
      onPressed: onPressed,
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 28),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.4, end: 1),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutBack,
          builder: (context, value, child) =>
              Transform.scale(scale: value, child: child),
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.okSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Symbols.check_rounded,
              size: 36,
              color: AppColors.ok,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l10n.maintenanceMarkDoneCompletedTitle,
          style: theme.textTheme.displaySmall?.copyWith(
            fontSize: 22,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.maintenanceMarkDoneCompletedSubtitle(days),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
