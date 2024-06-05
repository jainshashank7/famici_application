part of 'map_viewer_cubit.dart';

abstract class MapViewerState extends Equatable {
  const MapViewerState();
}

class MapViewerInitial extends MapViewerState {
  final CameraPosition cameraPosition = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 12,
  );
  @override
  List<Object> get props => [cameraPosition];
}

class MapViewerLoaded extends MapViewerState {
  final Marker marker;
  final CameraPosition cameraPosition;
  final Address current;
  MapViewerLoaded(this.current)
      : marker = current.toMarker(),
        cameraPosition = CameraPosition(
          target: current.toMarker().position,
          zoom: 12,
        );
  @override
  List<Object> get props => [marker, cameraPosition, current];
}
