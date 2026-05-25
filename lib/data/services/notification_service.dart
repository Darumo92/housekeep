import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String channelId = 'housekeep_reminders';
  static const String channelName = 'HouseKeep reminders';
  static const String channelDescription =
      'Reminders for upcoming maintenance, documents and warranties';

  final FlutterLocalNotificationsPlugin _plugin;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  Future<void> init() async {
    if (_initialized) return;
    await _initTimezone();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(settings);
    await _createAndroidChannel();
    _initialized = true;
  }

  Future<void> _initTimezone() async {
    tz_data.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (e) {
      debugPrint('[Notifications] tz fallback to UTC: $e');
      tz.setLocalLocation(tz.getLocation('Etc/UTC'));
    }
  }

  Future<void> _createAndroidChannel() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.high,
      ),
    );
  }

  Future<NotificationPermissionResult> requestPermissions() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final iosImpl = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    bool notifications = true;
    bool exactAlarms = true;

    if (androidImpl != null) {
      notifications =
          await androidImpl.requestNotificationsPermission() ?? false;
      exactAlarms =
          await androidImpl.requestExactAlarmsPermission() ?? false;
    }
    if (iosImpl != null) {
      notifications =
          await iosImpl.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return NotificationPermissionResult(
      notificationsGranted: notifications,
      exactAlarmsGranted: exactAlarms,
    );
  }

  Future<bool> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    String? payload,
  }) async {
    if (!_initialized) return false;
    final now = DateTime.now();
    if (!when.isAfter(now)) return false;

    final scheduled = tz.TZDateTime.from(when, tz.local);

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
    return true;
  }

  Future<void> cancel(int id) async {
    if (!_initialized) return;
    return _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    if (!_initialized) return;
    return _plugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> pending() async {
    if (!_initialized) return const [];
    return _plugin.pendingNotificationRequests();
  }

  Future<void> cancelByPayloadPrefix(String prefix) async {
    if (!_initialized) return;
    final pending = await _plugin.pendingNotificationRequests();
    for (final p in pending) {
      final payload = p.payload;
      if (payload != null && payload.startsWith(prefix)) {
        await _plugin.cancel(p.id);
      }
    }
  }
}

@immutable
class NotificationPermissionResult {
  const NotificationPermissionResult({
    required this.notificationsGranted,
    required this.exactAlarmsGranted,
  });

  final bool notificationsGranted;
  final bool exactAlarmsGranted;

  bool get allGranted => notificationsGranted && exactAlarmsGranted;
}
