part of 'manage_reminders_bloc.dart';

@immutable
abstract class ManageRemindersEvent {}

class FetchEventsAndRemindersData extends ManageRemindersEvent {
  FetchEventsAndRemindersData();
}

class SendEventsAndRemindersData extends ManageRemindersEvent {
  final String notes;
  final String title;
  final dynamic recurrenceModel;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final bool isEvent;

  SendEventsAndRemindersData(this.notes, this.title, this.recurrenceModel,
      this.startDate, this.endDate, this.isAllDay, this.isEvent);
}

class EditEventsAndRemindersWithoutRecurrenceData extends ManageRemindersEvent {
  final String? notes;
  final String title;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isAllDay;
  final bool isEvent;
  final int reminderId;
  final String recurrenceId;
  final bool byRecId;

  EditEventsAndRemindersWithoutRecurrenceData(
      {this.notes,
      required this.title,
      required this.reminderId,
      required this.startDate,
      required this.endDate,
      required this.isAllDay,
      required this.recurrenceId,
      required this.byRecId,
      required this.isEvent});
}

class EditEventsAndRemindersWithRecurrenceData extends ManageRemindersEvent {
  final String? notes;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final bool isEvent;
  final dynamic recurrenceModel;
  final String recurrenceId;

  EditEventsAndRemindersWithRecurrenceData(
      {this.notes,
      required this.title,
      required this.startDate,
      required this.endDate,
      required this.isAllDay,
      required this.recurrenceId,
      required this.recurrenceModel,
      required this.isEvent});
}

class DeleteEventsAndRemindersData extends ManageRemindersEvent {
  final int reminder_id;
  final bool isEvent;
  DeleteEventsAndRemindersData(
      {required this.reminder_id, required this.isEvent});
}

class DeleteEventsAndRemindersForByRecurrenceRule extends ManageRemindersEvent {
  final String recurrence_id;
  final bool isEvent;
  DeleteEventsAndRemindersForByRecurrenceRule(
      {required this.recurrence_id, required this.isEvent});
}
