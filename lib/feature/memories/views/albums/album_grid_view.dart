import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/router/router_delegate.dart';

import 'package:famici/feature/memories/blocs/album_bloc/album_bloc.dart';
import 'package:famici/feature/memories/views/media/album_options_action_buttons.dart';
import 'package:famici/feature/memories/widgets/albums_loading_effect.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import 'album_item.dart';

class AlbumsGrid extends StatelessWidget {
  AlbumsGrid({Key? key}) : super(key: key);

  late bool _isSelected = false;

  void checkSelected(AlbumState state) {
    for (int i = 0; i < state.albums.length; i++) {
      if (state.albums[i].isSelected == true) {
        _isSelected = true;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, AlbumState state) {
        checkSelected(state);

        if (state.albums.isEmpty && state.status != Status.loading) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                MemoriesStrings.youDontHaveAnyAlbums.tr(),
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.mediumFontSize,
                ),
              ),
              SvgPicture.asset(AssetImagePath.memoriesRequest,width: FCStyle.screenHeight*0.7),
              FCPrimaryButton(
                defaultSize: false,
                color: ColorPallet.kGreen,
                label: MemoriesStrings.createAlbum.tr(),
                labelColor: ColorPallet.kLightBackGround,
                onPressed: () {
                  // context
                  //     .read<ScreenDistributorBloc>()
                  //     .add(ShowCreateAlbumScreenEvent());
                  fcRouter.navigate(CreateAlbumRoute());
                },
              ),
            ],
          );
        }

        if (state.status == Status.loading) {
          return AlbumsLoadingEffect();
        }
        return Row(
          children: [
            Flexible(
              child: GridView.builder(
                //key: UniqueKey(),
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 32.0,
                  crossAxisSpacing: 32.0,
                  childAspectRatio: 6 / 5,
                ),
                itemCount: state.albums.length,
                padding: EdgeInsets.only(
                    top: 24,
                    bottom: 24,
                    left: 96,
                    right: state.selectingAlbumForOptions ? 30 : 96),
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  return AlbumItem(
                    isSelectable: state.selectingAlbumForOptions,
                    album: state.albums[index],
                    onPressed: state.selectingAlbumForOptions
                        ? () {
                            context
                                .read<AlbumBloc>()
                                .add(AlbumSelected(state.albums[index]));
                          }
                        : () {
                            // context
                            //     .read<ScreenDistributorBloc>()
                            //     .add(ShowAlbumScreenEvent());
                      fcRouter.navigate(ViewAlbumRoute());
                            context
                                .read<AlbumBloc>()
                                .add(SyncSelectedAlbum(state.albums[index]));
                          },
                    onSelect: () {
                      context
                          .read<AlbumBloc>()
                          .add(AlbumSelected(state.albums[index]));
                    },
                  );
                },
              ),
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 250),
                width: state.selectingAlbumForOptions ? 220 : 0,
                child: AlbumOptionsActionButtons(
                  disabled: !_isSelected,
                ))
          ],
        );
      },
    );
  }
}
