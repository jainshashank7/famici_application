part of 'my_apps_cubit.dart';

class MyAppsState extends Equatable {
  final bool isFullScreen;
  final List<UrlLink> links;
  final Status status;
  final bool initialPageLoaded;

  const MyAppsState({
    required this.isFullScreen,
    required this.links,
    required this.status,
    required this.initialPageLoaded,
  });

  factory MyAppsState.initial() {
    return const MyAppsState(
      isFullScreen: false,
      links: [],
      status: Status.loading,
      initialPageLoaded: false,
    );
  }

  MyAppsState copyWith({
    bool? isFullScreen,
    List<UrlLink>? links,
    Status? status,
    bool? initialPageLoaded,
  }) {
    return MyAppsState(
      isFullScreen: isFullScreen ?? this.isFullScreen,
      links: links ?? this.links,
      status: status ?? this.status,
      initialPageLoaded: initialPageLoaded ?? this.initialPageLoaded,
    );
  }

  @override
  List<Object?> get props => [
        isFullScreen,
        links,
        status,
        initialPageLoaded,
      ];

  bool get isLoaded => status == Status.success;
}
