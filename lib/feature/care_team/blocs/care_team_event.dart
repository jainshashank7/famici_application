part of 'care_team_bloc.dart';

abstract class CareTeamEvent extends Equatable {
  const CareTeamEvent();

  @override
  List<Object> get props => [];
}

class GetCareTeamMembers extends CareTeamEvent{
  const GetCareTeamMembers();
}
