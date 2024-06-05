part of 'app_info_cubit.dart';

class AppInfoState extends Equatable {
  const AppInfoState({
    required this.info,
  });

  final AppSupportInfo info;

  factory AppInfoState.initial() {
    return AppInfoState(
      info: AppSupportInfo(),
    );
  }

  AppInfoState copyWith({
    AppSupportInfo? info,
  }) {
    return AppInfoState(
      info: info ?? this.info,
    );
  }

  @override
  List<Object?> get props => [info];
}
