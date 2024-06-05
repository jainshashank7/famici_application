import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:famici/core/blocs/video_player/video_player_bloc.dart';
import 'package:famici/feature/memories/blocs/album_bloc/album_bloc.dart';
import 'package:famici/feature/memories/entities/barrel.dart';
import 'package:famici/feature/memories/views/media/media_item.dart';
import 'package:famici/feature/memories/widgets/photos_loading_effect.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/famici.theme.dart';
import 'package:video_player/video_player.dart';

import 'album_photo_view.dart';

class ViewAlbumScreen extends StatefulWidget {
  const ViewAlbumScreen({
    Key? key
  }) : super(key: key);
  @override
  State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
}

class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AlbumBloc>().add(FetchSelectedAlbumMedia());
  }

  @override
  Widget build(BuildContext context) {
    return FamiciScaffold(
      title: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, AlbumState state) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 50),
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(
              state.status == Status.loading
                  ? ""
                  : state.selectedAlbum.title ?? '',
              overflow: TextOverflow.ellipsis,
              style: FCStyle.textStyle.copyWith(
                fontSize: 40,
              ),
            ),
          );
        },
      ),
      child: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, AlbumState state) {
          if (state.status == Status.loading) {
            return PhotosLoadingEffect();
          }
          if (state.selectedAlbum.memories.isEmpty) {
            return Center(
              child: Text(
                MemoriesStrings.youDontHaveAnyPhotos.tr(),
                overflow: TextOverflow.ellipsis,
                style: FCStyle.textStyle.copyWith(
                  fontSize: 40,
                ),
              ),
            );
          }
          return GridView.builder(
              //key: UniqueKey(),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 3 / 2),
              itemCount: state.selectedAlbum.memories.length,
              padding: EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 96.0,
              ),
              itemBuilder: (
                BuildContext context,
                int idx,
              ) {
                return MediaItem(
                  media: state.selectedAlbum.memories[idx],
                  onPressed: () {
                    context.read<AlbumBloc>().add(SyncAlbumMemoryToShow(idx));
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlbumsPhotoView(initialIndex: idx);
                        });
                  },
                  onSelect: () {},
                );
              });
        },
      ),
    );
  }
}
