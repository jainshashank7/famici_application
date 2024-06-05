import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/screens/home_screen/widgets/logout_button.dart';
import 'package:famici/feature/memories/blocs/album_bloc/album_bloc.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/feature/memories/helpers/helper_methods.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../core/screens/home_screen/widgets/bottom_status_bar.dart';
import 'albums/album_grid_view.dart';
import 'media/media_gallery_view.dart';
import '../../../../core/offline/local_database/user_photos_db.dart';

class FamilyMemoriesScreen extends StatefulWidget {
  const FamilyMemoriesScreen({Key? key}) : super(key: key);

  @override
  _FamilyMemoriesScreenState createState() => _FamilyMemoriesScreenState();
}

class _FamilyMemoriesScreenState extends State<FamilyMemoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MemoriesBloc>().add(FetchMemories());
    context.read<AlbumBloc>().add(FetchInitialAlbums());
    context.read<NotificationBloc>().add(DismissAllMemoryNotificationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<MemoriesBloc, MemoriesState>(
            builder: (context, MemoriesState state) {
          return BlocBuilder<AlbumBloc, AlbumState>(
            builder: (context, albumState) {
              return FamiciScaffold(
                bottomNavbar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
                toolbarHeight: 140.h,
                title: Center(
                  child: Text(
                    'Photos',
                    style: FCStyle.textStyle
                        .copyWith(fontSize: 50.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                // trailing: _MemoriesTrailingButton(),
                topRight: LogoutButton(),
                leading: FCBackButton(
                    onPressed: state.selectMediaToShare
                        ? () {
                            context
                                .read<MemoriesBloc>()
                                .add(CancelMediaToShare());
                          }
                        : albumState.selectingAlbumForOptions
                            ? () {
                                context
                                    .read<AlbumBloc>()
                                    .add(CancelAlbumToOptions());
                              }
                            : null),
                child: Center(
                  child: state.showingPhotos
                      ? MediaGallery()
                      : !state.showingPhotos
                          ? AlbumsGrid()
                          : Center(
                              child: CircularProgressIndicator(
                                color: ColorPallet.kPrimaryTextColor,
                              ),
                            ),
                ),
              );
            },
          );
        });
      },
    );
  },
);
  }
}

class _MemoriesTrailingButton extends StatelessWidget {
  const _MemoriesTrailingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoriesBloc, MemoriesState>(
      builder: (context, MemoriesState state) {
        if (state.showingPhotos) {
          if (state.media.isNotEmpty) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!state.selectMediaToShare)
                  FCPrimaryButton(
                    defaultSize: false,
                    height: 40,
                    width: FCStyle.blockSizeHorizontal * 9,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    label: MemoriesStrings.options.tr(),
                    onPressed: state.status != MemoriesStatus.loading
                        ? () {
                            context
                                .read<MemoriesBloc>()
                                .add(ToggleSelectMediaToShare());
                          }
                        : () {},
                  ),
                SizedBox(width: FCStyle.blockSizeHorizontal),
                state.selectMediaToShare
                    ? FCMaterialButton(
                        defaultSize: false,
                        child: SizedBox(
                            height: 100.h,
                            width: 180.w,
                            child: Center(
                              child: Text(
                                CommonStrings.cancel.tr(),
                                style: FCStyle.textStyle.copyWith(
                                  color: ColorPallet.kWhite,
                                  fontSize: 36.sp,
                                ),
                              ),
                            )),
                        color: ColorPallet.kDarkRed,
                        onPressed: () {
                          context
                              .read<MemoriesBloc>()
                              .add(CancelMediaToShare());
                        },
                      )
                    : FCPrimaryButton(
                        defaultSize: false,
                        height: 40,
                        width: FCStyle.blockSizeHorizontal * 10,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        label: MemoriesStrings.addMedia.tr(),
                        onPressed: state.status != MemoriesStatus.loading
                            ? () {
                                showSelectMethodToAddPhotos(context);
                              }
                            : () {},
                      ),
              ],
            );
          }
          return SizedBox.shrink();
        } else if (!state.showingPhotos) {
          return BlocBuilder<AlbumBloc, AlbumState>(
            builder: (context, AlbumState state) {
              return state.albums.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!state.selectingAlbumForOptions)
                          FCPrimaryButton(
                            defaultSize: false,
                            height: 40,
                            width: FCStyle.blockSizeHorizontal * 9,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            label: MemoriesStrings.options.tr(),
                            onPressed: state.status != Status.loading
                                ? () {
                                    context
                                        .read<AlbumBloc>()
                                        .add(ToggleSelectAlbumForOptions());
                                  }
                                : () {},
                          ),
                        SizedBox(width: 16.0),
                        state.selectingAlbumForOptions
                            ? FCMaterialButton(
                                defaultSize: false,
                                child: SizedBox(
                                    height: 100.h,
                                    width: 180.w,
                                    child: Center(
                                      child: Text(
                                        CommonStrings.cancel.tr(),
                                        style: FCStyle.textStyle.copyWith(
                                          color: ColorPallet.kWhite,
                                          fontSize: 36.sp,
                                        ),
                                      ),
                                    )),
                                color: ColorPallet.kDarkRed,
                                onPressed: () {
                                  context
                                      .read<AlbumBloc>()
                                      .add(CancelAlbumToOptions());
                                },
                              )
                            : FCPrimaryButton(
                                defaultSize: false,
                                height: 100.h,
                                width: 300.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.r,
                                  vertical: 10.r,
                                ),
                                label: MemoriesStrings.createAlbum.tr(),
                                onPressed: () {
                                  fcRouter.navigate(CreateAlbumRoute());
                                },
                              ),
                      ],
                    )
                  : SizedBox.shrink();
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class _MemoriesTitle extends StatelessWidget {
  const _MemoriesTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, AlbumState albumState) {
        return BlocBuilder<MemoriesBloc, MemoriesState>(
          builder: (context, MemoriesState state) {
            // if (albumState.albums.isEmpty && state.media.isEmpty) {
            //   return Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         HomeStrings.familyMemories.tr(),
            //         style: TextStyle(
            //           color: ColorPallet.kPrimaryTextColor,
            //           fontSize: FCStyle.mediumFontSize,
            //         ),
            //       ),
            //     ],
            //   );
            // }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FCSliderButton(
                  height: 78.h,
                  width: 520.w,
                  initialLeftSelected: state.showingPhotos,
                  leftChild: Text(MemoriesStrings.photos.tr()),
                  rightChild: Text(MemoriesStrings.albums.tr()),
                  onRightTap: () {
                    context.read<MemoriesBloc>().add(ToggleShowPhotos());
                    context.read<AlbumBloc>().add(CancelAlbumToOptions());
                  },
                  onLeftTap: () {
                    context.read<MemoriesBloc>().add(ToggleShowPhotos());
                    context.read<AlbumBloc>().add(CancelAlbumToOptions());
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Widget selectPhotosTitle() => Center(
      child: Text(
        MemoriesStrings.selectMedia.tr(),
        style: FCStyle.textHeaderStyle,
      ),
    );
