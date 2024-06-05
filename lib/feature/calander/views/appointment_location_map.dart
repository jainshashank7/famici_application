import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/feature/google_maps/blocs/map_viewer/map_viewer_cubit.dart';
import 'package:famici/feature/google_maps/screens/google_map_viewer.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/fc_calendar/fc_calendar_screen.dart';
import 'package:famici/shared/fc_popup_input/fc_popup_input_screen.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/strings/appointment_strings.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:famici/core/enitity/barrel.dart' as Loc;

import '../../google_maps/blocs/search_places/search_places_bloc.dart';

String _isoCountryCode = "";

class AppointmentLocationMapScreen extends StatefulWidget {
  const AppointmentLocationMapScreen({
    Key? key,
    required ManageAppointmentBloc appointmentBloc,
  })  : _appointmentBloc = appointmentBloc,
        super(key: key);

  final ManageAppointmentBloc _appointmentBloc;

  @override
  _AppointmentLocationMapScreenState createState() =>
      _AppointmentLocationMapScreenState();
}

class _AppointmentLocationMapScreenState
    extends State<AppointmentLocationMapScreen> {
  //TODO:remove seacrh
  final SearchPlacesBloc _placesBloc = SearchPlacesBloc();
  late MapViewerCubit _mapCubit;

  @override
  void initState() {
    _mapCubit = MapViewerCubit(
      initial: widget._appointmentBloc.state.location,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupScaffold(
      width: 1820.w,
      height: 900.h,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.sp, vertical: 36.sp),
            child: Text(
              AppointmentStrings.addLocation.tr(),
              style: FCStyle.textHeaderStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 60.sp,
              right: 60.sp,
              bottom: 60.sp,
              top: 120.sp,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GoogleMapViewer(
                    cubit: _mapCubit,
                  ),
                ),
                SizedBox(width: 48.sp),
                SizedBox(
                  width: 500.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppointmentStrings.findLocation.tr(),
                        style: FCStyle.textHeaderStyle,
                      ),
                      SizedBox(height: 16.sp),
                      InkWell(
                        onTap: () {
                          showSearchBar(context, _mapCubit, _placesBloc)
                              .then((value) {
                            _placesBloc.add(ResetPlacesEvent());
                          });
                        },
                        child: BlocBuilder<MapViewerCubit, MapViewerState>(
                          bloc: _mapCubit,
                          builder: (context, state) {
                            if (state is MapViewerLoaded) {
                              return ShadowInputBox(
                                initial: state.current.isValid
                                    ? state.current.formattedAddress
                                    : CommonStrings.search.tr(),
                              );
                            }
                            return ShadowInputBox(
                              initial: CommonStrings.search.tr(),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 56.sp),
                      Text(
                        AppointmentStrings.orJustTap.tr(),
                        style: FCStyle.textStyle,
                      ),
                      Expanded(
                        child: BlocBuilder<MapViewerCubit, MapViewerState>(
                          bloc: _mapCubit,
                          builder: (context, state) {
                            if (state is MapViewerLoaded) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 56.sp),
                                  Text(
                                    AppointmentStrings.selectedLocation.tr(),
                                    style: FCStyle.textHeaderStyle,
                                  ),
                                  SizedBox(height: 16.sp),
                                  Text(
                                    state.current.formattedAddress,
                                    style: FCStyle.textStyle,
                                  ),
                                ],
                              );
                            }

                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 60.sp,
            bottom: 48.sp,
            child: BlocBuilder<MapViewerCubit, MapViewerState>(
              bloc: _mapCubit,
              builder: (context, state) {
                if (state is MapViewerLoaded) {
                  return NextButton(
                      hasIcon: false,
                      disabled: !state.current.isValid,
                      onPressed: () {
                        widget._appointmentBloc
                            .add(AppointmentChangeLocation(state.current));

                        fcRouter.pop();
                      },
                      label: AppointmentStrings.addLocation.tr(),
                      size: Size(320.w, 80.h));
                }

                return NextButton(
                    hasIcon: false,
                    disabled: true,
                    onPressed: () {},
                    label: AppointmentStrings.addLocation.tr(),
                    size: Size(320.w, 80.h));
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: CloseIconButton(
              margin: EdgeInsets.only(top: 8.sp, right: 16.sp),
              size: 100.sp,
            ),
          )
        ],
      ),
    );
  }

  Future<void> showSearchBar(
    context,
    MapViewerCubit mapCubit,
    SearchPlacesBloc placesBloc,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FamiciScaffold(
          leading: FCBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          child: Center(
            child: SizedBox(
              width: 1000.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FCTextFormField(
                    textInputAction: TextInputAction.done,
                    autoFocus: true,
                    onChanged: (value) {
                      placesBloc.add(FindPlacesEvent(query: value));
                    },
                  ),
                  SizedBox(height: 40.sp),
                  Expanded(
                    child: BlocBuilder<SearchPlacesBloc, SearchPlacesState>(
                      bloc: placesBloc,
                      builder: (context, state) {
                        if (state is PlacesNotFound) {
                          return Column(
                            children: [
                              Text(
                                "No results found.",
                                style: FCStyle.textStyle,
                              ),
                            ],
                          );
                        } else if (state is SearchPlacesLoading) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 56.sp,
                                child: LoadingScreen(),
                              ),
                            ],
                          );
                        } else if (state is PlacesLoadingFailed) {
                          return Column(
                            children: [
                              Text(state.message, style: FCStyle.textStyle),
                            ],
                          );
                        } else if (state is PlacesLoaded) {
                          return ListView.builder(
                            itemCount: state.places.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.location_on_rounded,
                                  color: ColorPallet.kPrimaryTextColor,
                                ),
                                onTap: () {
                                  mapCubit.syncAddress(state.places[index]);
                                  Navigator.pop(context);
                                },
                                title: Text(
                                  state.places[index].formattedAddress,
                                  style: FCStyle.textStyle,
                                ),
                              );
                            },
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShadowInputBox extends StatelessWidget {
  const ShadowInputBox({Key? key, String? initial})
      : initial = initial ?? '',
        super(key: key);

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 448.w,
      height: 80.h,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: ColorPallet.kWhite,
        border: Border.all(
          color: ColorPallet.kGrey,
          width: 4.0,
        ),
      ),
      child: Text(
        initial,
        style: FCStyle.textStyle.copyWith(
          color: ColorPallet.kBrown.withOpacity(0.7),
        ),
      ),
    );
  }
}
