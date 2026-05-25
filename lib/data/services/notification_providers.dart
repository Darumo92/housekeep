import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'notification_scheduler.dart';
import 'notification_service.dart';

part 'notification_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}

@Riverpod(keepAlive: true)
NotificationScheduler notificationScheduler(NotificationSchedulerRef ref) {
  return NotificationScheduler(service: ref.watch(notificationServiceProvider));
}
