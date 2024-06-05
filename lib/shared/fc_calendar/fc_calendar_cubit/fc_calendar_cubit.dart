import 'package:bloc/bloc.dart';
import 'package:famici/shared/fc_calendar/fc_calendar_cubit/fc_calendar_state.dart';

class FCCalendarCubit extends Cubit<FCCalendarState> {
  FCCalendarCubit(DateTime? date) : super(FCCalendarState.initial(date));

  void incrementMonth() async {
    DateTime date = state.date;
    DateTime newDate =
        DateTime(date.year, date.month + 1, 1, date.hour, date.minute);
    emit(state.copyWith(date: newDate));
  }

  void decrementMonth() async {
    DateTime date = state.date;
    DateTime newDate =
        DateTime(date.year, date.month - 1, 1, date.hour, date.minute);
    emit(state.copyWith(date: newDate));
  }

  void changeDay(int day) async {
    DateTime date = state.date;
    DateTime newDate =
        DateTime(date.year, date.month, day, date.hour, date.minute);
    emit(state.copyWith(date: newDate));
  }

  void incrementHour() async {
    DateTime date = state.date;
    DateTime newDate = date.add(Duration(hours: 1));
    emit(state.copyWith(date: newDate));
  }

  void decrementHour() async {
    DateTime date = state.date;
    DateTime newDate = date.subtract(Duration(hours: 1));
    emit(state.copyWith(date: newDate));
  }

  void incrementMinute() async {
    DateTime date = state.date;
    DateTime newDate = date.add(Duration(minutes: 1));
    emit(state.copyWith(date: newDate));
  }

  void decrementMinute() async {
    DateTime date = state.date;
    DateTime newDate = date.subtract(Duration(minutes: 1));
    emit(state.copyWith(date: newDate));
  }

  void incrementAMPM() async {
    DateTime date = state.date;
    DateTime newDate = date.add(Duration(hours: 12));
    emit(state.copyWith(date: newDate));
  }

  void decrementAMPM() async {
    DateTime date = state.date;
    DateTime newDate = date.subtract(Duration(hours: 12));
    emit(state.copyWith(date: newDate));
  }
}
