part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class IncrementGlobalBy extends NotificationEvent {
  const IncrementGlobalBy({this.value = 1});
  final int value;
  @override
  List<Object?> get props => [value];
}

class DecrementGlobalBy extends NotificationEvent {
  const DecrementGlobalBy({this.value = 1});
  final int value;
  @override
  List<Object?> get props => [value];
}

class ClearAllNotification extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

class OnSetNotificationsEvent extends NotificationEvent {
  final String notificationData;

  const OnSetNotificationsEvent(this.notificationData);

  @override
  List<Object?> get props => [notificationData];
}

class MessageReceivedNotificationEvent extends NotificationEvent {
  final Message message;

  const MessageReceivedNotificationEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageRemovedNotificationEvent extends NotificationEvent {
  final Message message;

  const MessageRemovedNotificationEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class AllMessageRemovedNotificationEvent extends NotificationEvent {
  final String contactId;

  const AllMessageRemovedNotificationEvent(this.contactId);

  @override
  List<Object?> get props => [contactId];
}

class _HandleCallReceiptNotificationEvent extends NotificationEvent {
  final Message message;

  const _HandleCallReceiptNotificationEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class SyncMemoryNotificationEvent extends NotificationEvent {
  final Notification notification;

  const SyncMemoryNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class SyncMedicationNotificationEvent extends NotificationEvent {
  final Notification notification;

  const SyncMedicationNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class SyncAppointmentNotificationEvent extends NotificationEvent {
  final Notification notification;

  const SyncAppointmentNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class SyncActivityReminderNotificationEvent extends NotificationEvent {
  final Notification notification;
  const SyncActivityReminderNotificationEvent(this.notification);
  @override
  List<Object?> get props => [notification];
}

class SyncDashboardBuilderNotificationEvent extends NotificationEvent {
  final Notification notification;

  const SyncDashboardBuilderNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class SyncScheduledAppointmentNotificationEvent extends NotificationEvent {
  final Notification notification;

  const SyncScheduledAppointmentNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class SyncScheduledMedicationNotificationEvent extends NotificationEvent {
  final Notification notification;

  const SyncScheduledMedicationNotificationEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}

class DismissMemoryNotificationEvent extends NotificationEvent {
  final String notificationId;

  const DismissMemoryNotificationEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class DismissAllMemoryNotificationEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

class DismissAllEventsNotificationEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

class DismissAllMedicationNotificationEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

class SyncInitialNotificationEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}
