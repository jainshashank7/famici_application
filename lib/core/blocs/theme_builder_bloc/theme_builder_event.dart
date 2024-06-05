part of 'theme_builder_bloc.dart';

abstract class ThemeBuilderEvent {}

class FetchDetailsEvent extends ThemeBuilderEvent {
  bool hasUpdate = false; Status? updationType = Status.initial;
  FetchDetailsEvent({required this.hasUpdate,this.updationType});
}
class SetDetailsEvent extends ThemeBuilderEvent {
  SetDetailsEvent();
}

class SubscribeToDashboardChangeEvent extends ThemeBuilderEvent {
  SubscribeToDashboardChangeEvent();
}
