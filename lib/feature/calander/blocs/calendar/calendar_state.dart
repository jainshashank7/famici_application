part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  CalendarState(
      {required this.eventController,
      required this.currentView,
      required this.loading,
      required this.appointments,
      required this.appointmentsMonth,
      required this.deleteFinished,
      required this.startDate,
      required this.endDate,
      required this.calendarView,
      required this.appointmentsThisWeek,
      required this.isLoadingThisWeekAppointments,
      required this.isDeleting,
      required this.currentDate,
      required this.pageController,
      required this.rem,
      required this.remindersThisWeek,
      required this.remindersThisMonth,
      required this.selectedAppointment,
      required this.icalEvents,
      required this.icalLinks,
      required this.additionStatus,
      required this.deletionStatus,
      required this.editionStatus,
        required this.activityReminder,
        required this.activityReminderThisWeek,
        required this.activityReminderThisMonth});

  final EventController eventController;
  final List<ICalURL> icalLinks;
  final CalendarView currentView;
  final DateTime currentDate;
  final bool loading;
  final List<Appointment> appointments;
  final List<Appointment> appointmentsMonth;
  final bool deleteFinished;
  final DateTime startDate;
  final DateTime endDate;
  final int calendarView;
  final List<Appointment> appointmentsThisWeek;
  final bool isLoadingThisWeekAppointments;
  final PageController pageController;
  final List<Reminders> rem;
  final List<Reminders> remindersThisWeek;
  final List<Reminders> remindersThisMonth;
  final List<ActivityReminder> activityReminder;
  final List<ActivityReminder> activityReminderThisWeek;
  final List<ActivityReminder> activityReminderThisMonth;
  final Appointment selectedAppointment;
  List<CalendarEventData> icalEvents = [];
  EventStatus additionStatus;
  EventStatus deletionStatus;
  EventStatus editionStatus;

  final bool isDeleting;

  static Map<String, String> recurrenceTypes = {
    "DoesNotRepeat": AppointmentStrings.doesNotRepeat.tr(),
    "Daily": AppointmentStrings.daily.tr(),
    "Weekly": AppointmentStrings.weekly.tr(),
    "LastDayOfMonth": AppointmentStrings.lastDayOfMonth.tr(),
    "Annually": AppointmentStrings.annually.tr(),
    "EveryWeekDay": AppointmentStrings.everyWeekDay.tr()
  };

  factory CalendarState.initial() {
    return CalendarState(
        additionStatus: EventStatus.initial,
        deletionStatus: EventStatus.initial,
        editionStatus: EventStatus.initial,
        icalLinks: [],
        eventController: EventController(),
        currentView: CalendarView.day,
        currentDate: DateTime.now(),
        loading: false,
        appointments: [],
        icalEvents: [],
        appointmentsMonth: [],
        deleteFinished: false,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 7)),
        calendarView: 1,
        appointmentsThisWeek: [],
        isLoadingThisWeekAppointments: false,
        isDeleting: false,
        pageController: PageController(),
        selectedAppointment: Appointment(),
        rem: [],
        remindersThisMonth: [],
        remindersThisWeek: [],
        activityReminder: [],
        activityReminderThisWeek: [],
        activityReminderThisMonth: []);
  }

  CalendarState copyWith(
      {EventController? eventController,
      CalendarView? currentView,
      bool? loading,
      List<Appointment>? appointments,
      List<Appointment>? appointmentsMonth,
      bool? deleteFinished,
      DateTime? startDate,
      DateTime? endDate,
      int? calendarView,
      List<Appointment>? appointmentsThisWeek,
      bool? isLoadingThisWeekAppointments,
      bool? isDeleting,
      DateTime? currentDate,
      PageController? pageController,
      Appointment? selectedAppointment,
      List<Reminders>? rem,
      List<Reminders>? remindersThisWeek,
      List<Reminders>? remindersThisMonth,
      List<CalendarEventData>? icalEvents,
      List<ICalURL>? icalLinks,
      EventStatus? deletionStatus,
      EventStatus? additionStatus,
      EventStatus? editionStatus,
        List<ActivityReminder>? activityReminder,
        List<ActivityReminder>? activityReminderThisWeek,
        List<ActivityReminder>? activityReminderThisMonth}) {
    return CalendarState(
        deletionStatus: deletionStatus ?? this.deletionStatus,
        additionStatus: additionStatus ?? this.additionStatus,
        editionStatus: editionStatus ?? this.editionStatus,
        icalLinks: icalLinks ?? this.icalLinks,
        icalEvents: icalEvents ?? this.icalEvents,
        eventController: eventController ?? this.eventController,
        currentView: currentView ?? this.currentView,
        currentDate: currentDate ?? this.currentDate,
        loading: loading ?? this.loading,
        appointments: appointments ?? this.appointments,
        appointmentsMonth: appointmentsMonth ?? this.appointmentsMonth,
        deleteFinished: deleteFinished ?? this.deleteFinished,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        calendarView: calendarView ?? this.calendarView,
        appointmentsThisWeek: appointmentsThisWeek ?? this.appointmentsThisWeek,
        isLoadingThisWeekAppointments:
            isLoadingThisWeekAppointments ?? this.isLoadingThisWeekAppointments,
        isDeleting: isDeleting ?? this.isDeleting,
        pageController: pageController ?? this.pageController,
        rem: rem ?? this.rem,
        remindersThisWeek: remindersThisWeek ?? this.remindersThisWeek,
        selectedAppointment: selectedAppointment ?? this.selectedAppointment,
        remindersThisMonth: remindersThisMonth ?? this.remindersThisMonth,
        activityReminder: activityReminder ?? this.activityReminder,
        activityReminderThisWeek:
            activityReminderThisWeek ?? this.activityReminderThisWeek,
        activityReminderThisMonth:
            activityReminderThisMonth ?? this.activityReminderThisMonth);
  }

  bool get isDaily => currentView == CalendarView.day;

  bool get isWeekly => currentView == CalendarView.week;

  bool get isMonthly => currentView == CalendarView.month;

  bool get isYearly => currentView == CalendarView.year;

  @override
  List<Object?> get props => [
        eventController,
        currentDate,
        currentView,
        loading,
        appointments,
        appointmentsMonth,
        deleteFinished,
        startDate,
        endDate,
        appointmentsThisWeek,
        isLoadingThisWeekAppointments,
        isDeleting,
        pageController,
        selectedAppointment,
        rem,
        remindersThisWeek,
        remindersThisMonth,
        icalEvents,
        icalLinks,
        deletionStatus,
        editionStatus,
        additionStatus,
        activityReminder,
        activityReminderThisWeek,
        activityReminderThisMonth
      ];
}

enum CalendarView { day, week, month, year }
