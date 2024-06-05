import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:famici/feature/google_maps/entities/address.dart';
import 'package:famici/feature/google_maps/repository/map_repository.dart';

part 'search_places_event.dart';
part 'search_places_state.dart';

class SearchPlacesBloc extends Bloc<SearchPlacesEvent, SearchPlacesState> {
  SearchPlacesBloc() : super(SearchPlacesInitial()) {
    on<FindPlacesEvent>(_onFindPlacesEvent);
    on<ResetPlacesEvent>(_onResetPlacesEvent);
  }

  final MapRepository _mapRepo = MapRepository();

  Future<void> _onFindPlacesEvent(FindPlacesEvent event, emit) async {
    emit(SearchPlacesLoading());
    try {
      if (event.query.isNotEmpty) {
        List<Address> _addresses = await _mapRepo.findPlaces(event.query);
        if (_addresses.isEmpty) {
          emit(PlacesNotFound());
        } else {
          emit(PlacesLoaded(_addresses));
        }
      } else {
        emit(SearchPlacesInitial());
      }
    } catch (err) {
      DebugLogger.debug(err);
      emit(PlacesLoadingFailed(err.toString()));
    }
  }

  Future<void> _onResetPlacesEvent(ResetPlacesEvent event, emit) async {
    emit(SearchPlacesInitial());
  }
}
