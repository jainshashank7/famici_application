part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  ThemeState({Brightness? mode}) : mode = mode ?? ColorPallet().theme;

  final Brightness mode;

  factory ThemeState.initial() {
    return ThemeState(mode: ColorPallet().theme);
  }

  ThemeState copyWith({Brightness? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }

  bool get isDark => mode == Brightness.dark;

  @override
  List<Object?> get props => [mode];

  @override
  String toString() {
    return ''' ThemeState { Brightness : ${mode.toString()} } ''';
  }
}
