# Expiry / overdue notifications — design

Date: 2026-06-04
Area: `lib/data/services/notification_scheduler.dart`

## Problem

Notifications only fire on discrete tiers (Pro 90/30/7, Free 1). When an
entity is added/edited with all tiers already in the past, nothing is
scheduled — the reminder is silently dropped. There is also no "it has
expired" notification, and existing tiers fire at midnight (00:00).

## Scope

Documents, warranties and maintenances. Tiers unchanged.

## Behaviour

Reference date `R`: document.expiryDate / warranty expiry / maintenance.nextDueAt.

Three notification kinds per entity, all under the existing prefix
(`hk:d|w|m:<id>:`) so cancel/reschedule clears them together:

| Kind     | Payload        | When |
|----------|----------------|------|
| Tier     | `<prefix><days>` | `09:00` on `R − days`, if future |
| Recovery | `<prefix>soon`   | If no tier stayed future AND `R` still future → next `09:00` |
| Expired  | `<prefix>expired`| `09:00` on `R`; if that is not future → next `09:00` |

All times normalized to **09:00** local of the target day (fixes the
midnight firing).

### Algorithm

```
cancelByPayloadPrefix(prefix)
anyTier = false
for days in tiers (days >= 0):
    when = atNineAm(R - days)
    if when > now: schedule tier; anyTier = true
if !anyTier and R > now:
    schedule recovery at nextNineAm(now), body = tierBody(remainingDays)
expiredWhen = atNineAm(R); if expiredWhen <= now: expiredWhen = nextNineAm(now)
if expiredWhen > now: schedule expired
```

- `atNineAm(d)` = `DateTime(d.year, d.month, d.day, 9)`
- `nextNineAm(now)` = today 09:00 if still future, else tomorrow 09:00
- `remainingDays` = `R.difference(now).inDays`

Recovery reuses the existing tier body (no new "soon" string). Expired
needs new strings.

### Cases

- Expires in 9 days, Pro → tier 7 (09:00) + expired on day 9.
- Expires in 5 days, Pro → all tiers past → recovery next 09:00 + expired day 5.
- Already expired on save → only expired at next 09:00 ("ya caducó").

## Strings

New l10n pairs (es/en): `notificationDocumentExpiredTitle/Body`,
`notificationWarrantyExpiredTitle/Body`,
`notificationMaintenanceOverdueTitle/Body`. Regenerate with `flutter gen-l10n`.

`NotificationTexts` gains matching fields.

## Tests

`test/data/services/notification_scheduler_test.dart`: existing tier
assertions updated to 09:00; new cases for recovery, expired-future,
expired-past, already-expired. `now` injected.

## Out of scope

Daily countdown in final days. Startup `rescheduleAll` (plugin already
reschedules on BOOT_COMPLETED + MY_PACKAGE_REPLACED).
