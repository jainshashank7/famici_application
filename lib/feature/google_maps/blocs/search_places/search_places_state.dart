part of 'search_places_bloc.dart';

abstract class SearchPlacesState extends Equatable {
  const SearchPlacesState();
}

class SearchPlacesInitial extends SearchPlacesState {
  @override
  List<Object> get props => [];
}

class SearchPlacesLoading extends SearchPlacesState {
  @override
  List<Object> get props => [];
}

class PlacesLoaded extends SearchPlacesState {
  final List<Address> places;

  const PlacesLoaded(this.places);
  @override
  List<Object> get props => [places];
}

class PlacesLoadingFailed extends SearchPlacesState {
  final String message;

  const PlacesLoadingFailed(this.message);
  @override
  List<Object> get props => [message];
}

class PlacesNotFound extends SearchPlacesState {
  const PlacesNotFound();
  @override
  List<Object> get props => [];
}
