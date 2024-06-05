part of 'search_places_bloc.dart';

abstract class SearchPlacesEvent extends Equatable {
  const SearchPlacesEvent();
}

class FindPlacesEvent extends SearchPlacesEvent {
  final String query;
  const FindPlacesEvent({required String? query}) : query = query ?? '';

  @override
  List<Object?> get props => [query];
}

class ResetPlacesEvent extends SearchPlacesEvent {
  @override
  List<Object?> get props => [];
}
