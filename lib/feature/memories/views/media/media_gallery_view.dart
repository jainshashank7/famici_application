import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:famici/feature/camera/helpers/helper_methods.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/feature/memories/entities/barrel.dart';
import 'package:famici/feature/memories/helpers/helper_methods.dart';
import 'package:famici/feature/memories/views/media/action_buttons_in_share.dart';
import 'package:famici/feature/memories/widgets/photos_loading_effect.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import 'media_item.dart';
import 'memory_viewer_with_slider.dart';

class MediaGallery extends StatelessWidget {
  MediaGallery({
    Key? key,
  }) : super(key: key);

  late bool _isSelected = false;

  void checkSelected(MemoriesState state) {
    for (int i = 0; i < state.media.length; i++) {
      if (state.media[i].isSelected == true) {
        _isSelected = true;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoriesBloc, MemoriesState>(
      builder: (context, state) {
        checkSelected(state);
        if (state.media.isEmpty && state.status != MemoriesStatus.loading) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 16),
            // padding: EdgeInsets.only(
            //     right: 53 * FCStyle.fem,
            //     left: 0,
            //     top: 35 * FCStyle.fem,
            //     bottom: 43 * FCStyle.fem),

            decoration: BoxDecoration(
                color: Color.fromARGB(224, 255, 255, 255),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                SvgPicture.asset(
                  VitalIcons.noPhotos,
                  width: 130,
                ),
                SizedBox(
                  height: 32,
                ),
                Text(
                  'No Photo Yet',
                  style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: 56 * FCStyle.fem,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  MemoriesStrings.youDontHaveAnyPhotos.tr(),
                  style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: 25 * FCStyle.fem,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 250,
                  alignment: Alignment.center,
                  child: FCMaterialButton(
                    elevation: 0,
                    isBorder: false,
                    color: ColorPallet.kSecondary,
                    defaultSize: true,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: () {
                      showSelectMethodToAddPhotos(context);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            VitalIcons.addDevice,
                            color: ColorPallet.kSecondaryText,
                            width: 28,
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Text(
                            'Add your first photo',
                            style: FCStyle.textStyle.copyWith(
                              color: ColorPallet.kSecondaryText,
                              fontWeight: FontWeight.w700,
                              fontSize: 23 * FCStyle.fem,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

                // FCPrimaryButton(
                //   defaultSize: false,
                //   color: ColorPallet.kGreen,
                //   label: MemoriesStrings.takeYourFirstPhoto.tr(),
                //   labelColor: ColorPallet.kLightBackGround,
                //   onPressed: () {
                //     showSelectMethodToAddPhotos(context);
                //   },
                // )
              ],
            ),
          );
        }
        if (state.status == MemoriesStatus.loading) {
          return PhotosLoadingEffect();
        }

        return Row(
          children: [
            Container(
              child: Flexible(
                child: Container(
                  margin:
                      EdgeInsets.only(right: 10, left: 20, top: 0, bottom: 16),
                  // padding: EdgeInsets.only(
                  //     right: 53 * FCStyle.fem,
                  //     left: 0,
                  //     top: 35 * FCStyle.fem,
                  //     bottom: 43 * FCStyle.fem),
                  padding: EdgeInsets.only(
                      // top: 17 * FCStyle.fem,
                      left: 0 * FCStyle.fem,
                      right: 0 * FCStyle.fem),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(236, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10)),
                  child: RawScrollbar(
                    trackVisibility: true,
                    radius: Radius.circular(10),
                    thumbColor: ColorPallet.kSecondary,
                    thickness: 5,
                    thumbVisibility: true,
                    child: GridView.builder(
                        //key: UniqueKey(),
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 1.2),
                        itemCount: state.media.length,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 25,
                        ),
                        itemBuilder: (
                          BuildContext context,
                          int index,
                        ) {
                          return MediaItem(
                            isSelectable: true,
                            media: state.media[index],
                            onPressed: state.selectMediaToShare
                                ? () {
                                    context
                                        .read<MemoriesBloc>()
                                        .add(MediaSelected(state.media[index]));
                                  }
                                : () {
                                    context
                                        .read<MemoriesBloc>()
                                        .add(SyncMemoryToSlider(index));
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MemoryViewerWithSlider();
                                        }).then((value) {
                                      context
                                          .read<MemoriesBloc>()
                                          .add(ResetMemorySliderIndex());
                                    });
                                  },
                            onSelect: () {
                              context
                                  .read<MemoriesBloc>()
                                  .add(MediaSelected(state.media[index]));
                            },
                          );
                        }),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: 250 * FCStyle.fem,
              child: ActionButtonsInShare(
                disabled: !_isSelected,
              ),
            ),
          ],
        );
      },
    );
  }
}
