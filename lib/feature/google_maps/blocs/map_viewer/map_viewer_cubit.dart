import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:famici/feature/google_maps/entities/address.dart';
import 'package:famici/feature/google_maps/repository/map_repository.dart';

part 'map_viewer_state.dart';

class MapViewerCubit extends Cubit<MapViewerState> {
  MapViewerCubit({this.onLocationChange, Address? initial})
      : super(initial != null && initial.isValid
            ? MapViewerLoaded(initial)
            : MapViewerInitial());

  final MapRepository _mapRepo = MapRepository();

  final Function(Address)? onLocationChange;
  GoogleMapController? _controller;

  void syncAddress(Address location) async {
    emit(MapViewerLoaded(location));
    _animateTo(location);
  }

  void markerChanged(LatLng position) async {
    try {
      Address _address = await _mapRepo.findPlaceFromLatLong(position);
      emit(MapViewerLoaded(_address));
      onLocationChange?.call(_address);
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  void _animateTo(Address location) async {
    try {
      CameraUpdate _updated = CameraUpdate.newCameraPosition(
        CameraPosition(target: location.toMarker().position, zoom: 12),
      );
      _controller?.animateCamera(_updated);
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    _controller = controller;
  }
}
