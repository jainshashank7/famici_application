import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:photo_view/photo_view.dart';
import 'package:famici/feature/memories/blocs/album_bloc/album_bloc.dart';
import 'package:famici/feature/memories/entities/barrel.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

class AlbumsPhotoView extends StatelessWidget {
  AlbumsPhotoView({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: UniqueKey());

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    int previous = initialIndex;
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, AlbumState state) {
        int sign = state.currentMemory - previous;
        previous = state.currentMemory;
        return Scaffold(
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 48.0,
                  horizontal: 80.0,
                ),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                        position: Tween<Offset>(
                          end: Offset.zero,
                          begin: Offset(sign.sign * 1.0, 0.0),
                        ).animate(animation),
                        child: child);
                  },
                  child:
                      state.selectedAlbum.memories[state.currentMemory].type ==
                              MemoryType.photo
                          ? Center(
                              child: PhotoView(
                                customSize: Size(
                                    MediaQuery.of(context).size.width - 160,
                                    MediaQuery.of(context).size.height - 96),
                                minScale: PhotoViewComputedScale.contained,
                                initialScale:
                                    PhotoViewComputedScale.contained * 0.8,
                                key: UniqueKey(),
                                tightMode: true,
                                imageProvider: getImageProvider(state
                                    .selectedAlbum
                                    .memories[state.currentMemory]
                                    .url!),
                              ),
                            )
                          : FCVideoPlayer(
                              key: UniqueKey(),
                              videoUrl: state.selectedAlbum
                                  .memories[state.currentMemory].url!,
                            ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: CloseIconButton(),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40.0),
                  onTap: () {
                    context.read<AlbumBloc>().add(ShowPreviousAlbumMemory());
                  },
                  child: state.currentMemory != 0
                      ? Container(
                          padding: EdgeInsets.only(
                            left: 24.0,
                            right: 8.0,
                            top: 16.0,
                            bottom: 16.0,
                          ),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: FittedBox(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: ColorPallet.kPrimaryTextColor,
                              // size: 64.0,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ),
              state.currentMemory != state.selectedAlbum.memories.length - 1
                  ? Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40.0),
                        onTap: () {
                          context.read<AlbumBloc>().add(ShowNextAlbumMemory());
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.all(16.0),
                          child: FittedBox(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: ColorPallet.kPrimaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
