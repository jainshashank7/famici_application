part of 'education_bloc.dart';

abstract class EducationEvent {}

class OnGetEducationData extends EducationEvent {
  final String dashboardId;

  OnGetEducationData({required this.dashboardId});
}

class OnGetRssData extends EducationEvent {}

class OnSetPinStatus extends EducationEvent {
  final int id;
  final int status;

  OnSetPinStatus({required this.id, required this.status});
}

class OnChangeLikeStatus extends EducationEvent {
  final bool status;
  final int rssId;
  final int feedItemId;

  OnChangeLikeStatus({
    required this.feedItemId,
    required this.rssId,
    required this.status,
  });
}

class ShowEducationSearchResults extends EducationEvent {
  final String searchTerm;

  ShowEducationSearchResults({required this.searchTerm});
}

class ResetSearchResults extends EducationEvent{
  ResetSearchResults();
}

class OnGetLikesStatus extends EducationEvent {}
