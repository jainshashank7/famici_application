part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    required this.time,
    required this.date,
    required this.locked,
    required this.initialized,
  });

  final String time;
  final String date;
  final bool locked;
  final bool initialized;

  factory AppState.initial() {
    return AppState(
      time: '',
      date: '',
      locked: true,
      initialized: false,
    );
  }

  AppState copyWith({
    String? time,
    String? date,
    bool? locked,
    bool? initialized,
  }) {
    return AppState(
      time: time ?? this.time,
      date: date ?? this.date,
      locked: locked ?? this.locked,
      initialized: initialized ?? this.initialized,
    );
  }

  @override
  List<Object?> get props => [
        time,
        date,
        locked,
        initialized,
      ];

  @override
  String toString() {
    return '''
    time        : $time,
    date        : $date,
    locked      : $locked,
    initialized : $initialized
    ''';
  }
}
