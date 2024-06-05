part of 'kiosk_dashboard_bloc.dart';

abstract class KioskDashboardEvent {}

class FetchMainModuleDetailsEvent extends KioskDashboardEvent {
  bool hasUpdate = false;
  int dashboardUsed;
  FetchMainModuleDetailsEvent({required this.hasUpdate, required this.dashboardUsed});
}

class FetchMainModuleInfoEvent extends KioskDashboardEvent {
  FetchMainModuleInfoEvent();
}

class FetchSubModuleDetailsEvent extends KioskDashboardEvent {
  final int id;

  FetchSubModuleDetailsEvent({required this.id});
}

class FetchSubModuleInfoEvent extends KioskDashboardEvent {
  FetchSubModuleInfoEvent();
}

class FetchSubModuleLinksEvent extends KioskDashboardEvent {
  final int id;

  FetchSubModuleLinksEvent({required this.id});
}

class FetchSubModuleLinksInfoEvent extends KioskDashboardEvent {
  FetchSubModuleLinksInfoEvent();
}

class ResetDashboardMainModuleState extends KioskDashboardEvent {
  ResetDashboardMainModuleState();
}

class SubscribeToDashboardUpdationEvent extends KioskDashboardEvent {
  SubscribeToDashboardUpdationEvent();
}
class SubscribeToDashboardChangeEvent extends KioskDashboardEvent {
  SubscribeToDashboardChangeEvent();
}

class LoadMoreRSSFeeds extends KioskDashboardEvent{
  LoadMoreRSSFeeds({required this.addFeeds});
  final int addFeeds;

}

class ResetRSSFeedsCount extends KioskDashboardEvent{
  ResetRSSFeedsCount();
}
