part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {}

class ViewChanged extends CalendarEvent {
  final CalendarView view;

  ViewChanged(this.view);
}

class FetchCalendarDetailsEvent extends CalendarEvent {
  final DateTime startDate;
  final DateTime endDate;

  FetchCalendarDetailsEvent(this.startDate, this.endDate);
}

class saveICal extends CalendarEvent {
  final ICalURL ical;
  saveICal(this.ical);
}

class updateICal extends CalendarEvent {
  final ICalURL ical;
  updateICal(this.ical);
}

class deleteICal extends CalendarEvent {
  final String icalID;
  deleteICal(this.icalID);
}

class LoadAllICals extends CalendarEvent {
  LoadAllICals();
}

class RefreshICals extends CalendarEvent {
  RefreshICals();
}

class FetchThisWeekAppointmentsCalendarEvent extends CalendarEvent {
  final bool showLoader;

  FetchThisWeekAppointmentsCalendarEvent({
    this.showLoader = true,
  });
}

class FetchThisWeekRemindersCalendarEvent extends CalendarEvent {
  final bool showLoader;

  FetchThisWeekRemindersCalendarEvent({
    this.showLoader = false,
  });
}

class FetchMonthAppointments extends CalendarEvent {
  final bool showLoader;

  FetchMonthAppointments({
    this.showLoader = false,
  });
}

class CurrentCalendarViewChanged extends CalendarEvent {
  final CalendarView view;
  CurrentCalendarViewChanged(this.view);
}

class CurrentDateChanged extends CalendarEvent {
  final DateTime date;
  CurrentDateChanged(this.date);
}

class PageControllerChanged extends CalendarEvent {
  final PageController controller;
  PageControllerChanged(this.controller);
}

class ResetCalendarEvent extends CalendarEvent {}

class RefreshCalendarDetailsEvent extends CalendarEvent {}

class SelectedAppointmentDetails extends CalendarEvent {
  final Appointment appointment;
  SelectedAppointmentDetails(this.appointment);
}
