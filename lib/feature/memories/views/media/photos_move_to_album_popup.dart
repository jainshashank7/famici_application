import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/memories/blocs/album_bloc/album_bloc.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../albums/album_item.dart';

class PhotosMoveToAlbumPopup extends StatefulWidget {
  const PhotosMoveToAlbumPopup({Key? key}) : super(key: key);

  @override
  _PhotosMoveToAlbumPopupState createState() => _PhotosMoveToAlbumPopupState();
}

class _PhotosMoveToAlbumPopupState extends State<PhotosMoveToAlbumPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallet.kDarkBackGround,
      body: Container(
        color: ColorPallet.kBackground,
        margin: EdgeInsets.symmetric(vertical: FCStyle.screenHeight*0.02,horizontal: 10),
        child: Center(
          child: BlocBuilder<MemoriesBloc, MemoriesState>(
            builder: (context, MemoriesState memoriesState) {
              if (memoriesState.requestStatus == Status.success) {
                return _MovePhotosSuccess();
              }
              if (memoriesState.requestStatus == Status.initial) {
                return _MovePhotosDetailsForm();
              }
              if (memoriesState.requestStatus == Status.failure) {
                return Icon(Icons.close);
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class _MovePhotosDetailsForm extends StatelessWidget {
  const _MovePhotosDetailsForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.only(top: 32.0),
              alignment: Alignment.topCenter,
              child: Text(
                MemoriesStrings.selectAlbumToMovePhotos.tr(),
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.largeFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<AlbumBloc, AlbumState>(
              builder: (context, AlbumState state) {
                if (state.status == Status.loading) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 48.0),
                    child: CircularProgressIndicator(
                      color: ColorPallet.kPrimaryColor,
                    ),
                  );
                }
                if (state.albums.isEmpty) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    margin: EdgeInsets.only(top: 32.0),
                    alignment: Alignment.center,
                    child: Text(
                        MemoriesStrings.youDontHaveAnyAlbums.tr(),
                      style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.largeFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return IntrinsicHeight(
                  child:  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 40,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: FCStyle.screenHeight*0.8,
                              child: GridView.builder(
                                //key: UniqueKey(),
                                physics: BouncingScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 32.0,
                                  crossAxisSpacing: 32.0,
                                  childAspectRatio: 0.8,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: state.albums.length,
                                padding: EdgeInsets.symmetric(vertical: 24,horizontal: 50),
                                itemBuilder: (
                                    BuildContext context,
                                    int index,
                                    ) {
                                  return AlbumItem(
                                    isSelectable: state.selectingAlbumForOptions,
                                    album: state.albums[index],
                                    onPressed: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return FCConfirmDialog(
                                              message: MemoriesStrings.moveImagesToNAlbum.tr(
                                                args: [
                                                  state.albums[index].title??""
                                                ],
                                              ),
                                            );
                                          }).then((value) {
                                        if (value) {
                                          context.read<MemoriesBloc>().add(MoveMemories(state.albums[index].albumId??""));
                                          Navigator.pop(context);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),

                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CloseIconButton(
                onTap: () {
                  // context
                  //     .read<FamilyMemberCubit>()
                  //     .resetSelectMemberToShareMedia();
                  // context
                  //     .read<MemoriesBloc>()
                  //     .add(ResetSelectedMemberToShareMedia());
                   Navigator.pop(context);
                },
                size: 64,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MovePhotosSuccess extends StatelessWidget {
  const _MovePhotosSuccess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorPallet.kBrightGreen,
          ),
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.check,
            color: ColorPallet.kLightBackGround,
            size: 64,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 48.0),
          width: MediaQuery.of(context).size.width * 2 / 5,
          child: Text(
            CommonStrings.photosMoveSuccess.tr(),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: FCStyle.textStyle.copyWith(
              fontSize: FCStyle.mediumFontSize,
            ),
          ),
        ),
        FCPrimaryButton(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 32.0,
          ),
          onPressed: () {
            Navigator.pop(context);
            // context.read<MemoriesBloc>().add(CancelMediaToShare());
            // context.read<MemoriesBloc>().add(ShareMediaSuccess());
            // context.read<FamilyMemberCubit>().resetSelectMemberToShareMedia();
            // context.read<MemoriesBloc>().add(ResetSelectedMemberToShareMedia());
          },
          color: ColorPallet.kGreen,
          labelColor: ColorPallet.kLightBackGround,
          fontSize: FCStyle.mediumFontSize,
          fontWeight: FontWeight.bold,
          label: CommonStrings.done.tr(),
        )
      ],
    );
  }
}
