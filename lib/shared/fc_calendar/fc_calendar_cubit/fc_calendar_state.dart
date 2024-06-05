class FCCalendarState {
  FCCalendarState({required this.date});

  final DateTime date;

  factory FCCalendarState.initial(DateTime? date) {
    return FCCalendarState(date: date ?? DateTime.now());
  }

  FCCalendarState copyWith({DateTime? date}) {
    return FCCalendarState(date: date ?? this.date);
  }
}
