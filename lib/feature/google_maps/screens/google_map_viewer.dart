import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/google_maps/blocs/map_viewer/map_viewer_cubit.dart';

class GoogleMapViewer extends StatefulWidget {
  const GoogleMapViewer({Key? key, MapViewerCubit? cubit, bool? disabled})
      : mapViewerCubit = cubit,
        disabled = disabled ?? false,
        super(key: key);
  final MapViewerCubit? mapViewerCubit;
  final bool disabled;

  @override
  State<GoogleMapViewer> createState() => _GoogleMapViewerState();
}

class _GoogleMapViewerState extends State<GoogleMapViewer> {
  late MapViewerCubit _mapViewer;

  MapViewerCubit? get cubit => widget.mapViewerCubit;

  bool get markerDisabled => widget.disabled;

  @override
  void dispose() {
    _mapViewer.close();
    super.dispose();
  }

  @override
  void initState() {
    _mapViewer = cubit ?? MapViewerCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViewerCubit, MapViewerState>(
      bloc: _mapViewer,
      builder: (context, state) {
        if (state is MapViewerInitial) {
          return GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: state.cameraPosition,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              _mapViewer.onMapCreated(controller);
            },
            onLongPress: markerDisabled
                ? null
                : (position) {
                    _mapViewer.markerChanged(position);
                  },
            onTap: markerDisabled
                ? null
                : (position) {
                    _mapViewer.markerChanged(position);
                  },
          );
        } else if (state is MapViewerLoaded) {
          return GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: state.cameraPosition,
            markers: {state.marker},
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              _mapViewer.onMapCreated(controller);
            },
            onLongPress: markerDisabled
                ? null
                : (position) {
                    _mapViewer.markerChanged(position);
                  },
            onTap: markerDisabled
                ? null
                : (position) {
                    _mapViewer.markerChanged(position);
                  },
          );
        }
        return Center(child: LoadingScreen());
      },
    );
  }
}
