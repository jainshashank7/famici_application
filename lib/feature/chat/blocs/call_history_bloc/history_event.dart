part of 'history_bloc.dart';

@immutable
abstract class ManageHistoryEvent {}

class FetchCallHistoryData extends ManageHistoryEvent {
  FetchCallHistoryData();
}
