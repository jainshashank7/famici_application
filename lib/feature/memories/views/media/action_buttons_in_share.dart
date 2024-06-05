import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/feature/memories/views/media/create_option.dart';
import 'package:famici/feature/memories/views/media/photos_move_to_album_popup.dart';
import 'package:famici/feature/memories/views/media/share_photos_popup.dart';
import 'package:famici/shared/custom_snack_bar/fc_alert.dart';
import 'package:famici/shared/fc_coming_soon_popup.dart';
import 'package:famici/shared/fc_confirm_dialog.dart';
import 'package:famici/shared/fc_primary_button.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/memories_strings.dart';

import '../../helpers/helper_methods.dart';

class ActionButtonsInShare extends StatefulWidget {
  const ActionButtonsInShare({Key? key, required this.disabled})
      : super(key: key);
  final bool disabled;

  @override
  State<ActionButtonsInShare> createState() => _ActionButtonsInShareState();
}

class _ActionButtonsInShareState extends State<ActionButtonsInShare> {
  var _totalSelected = 0;
  bool _allSelected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      //width: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SizedBox(height: 40.r),
          BlocBuilder<MemoriesBloc, MemoriesState>(
              builder: (context, MemoriesState state) {
            return ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(ColorPallet.kPrimary)),
                onPressed: state.status != MemoriesStatus.loading
                    ? () {
                        showSelectMethodToAddPhotos(context);
                      }
                    : () {},
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        VitalIcons.addDevice,
                        color: ColorPallet.kPrimaryText,
                        width: 28,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Add Media',
                        style: TextStyle(
                            color: ColorPallet.kPrimaryText,
                            fontSize: 24 * FCStyle.fem,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ));
          }),
          const SizedBox(height: 10),
          BlocBuilder<MemoriesBloc, MemoriesState>(
              buildWhen: (current, previous) {
            var selectedCount = 0;
            for (int i = 0; i < previous.media.length; i++) {
              if (previous.media[i].isSelected &&
                  previous.media[i].mediaId != null) {
                selectedCount++;
              }
            }
            setState(() {
              _totalSelected = selectedCount;
            });
            if (selectedCount == previous.media.length) {
              _allSelected = true;
              return true;
            }
            _allSelected = false;
            return true;
          }, builder: (context, state) {
            return ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 255, 255, 255))),
                onPressed: () {
                  setState(() {
                    _allSelected = !_allSelected;
                  });
                  if (_allSelected) {
                    context.read<MemoriesBloc>().add(AllMediaSelected());
                  } else {
                    context.read<MemoriesBloc>().add(AllMediaDisSelected());
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _allSelected
                            ? Icon(
                                Icons.check_box_sharp,
                                color: ColorPallet.kSecondary,
                                size: 28,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                color: ColorPallet.kSecondary,
                                size: 28,
                              ),
                        // Container(
                        //   width: 20,
                        //   height: 20,
                        //   decoration: BoxDecoration(
                        //     color: _allSelected
                        //         ? ColorPallet.kBrightGreen
                        //         : Color.fromARGB(77, 255, 255, 255),
                        //     shape: BoxShape.rectangle,
                        //     borderRadius: BorderRadius.circular(9),
                        //     border: Border.all(
                        //       color: _allSelected
                        //           ? ColorPallet.kBrightGreen
                        //           : Colors.red,
                        //       width: 2,
                        //     ),
                        //   ),
                        //   child: _allSelected
                        //       ? Icon(
                        //           Icons.check_rounded,
                        //           color: ColorPallet.kLightBackGround,
                        //           weight: 700,
                        //         )
                        //       : SizedBox.shrink(),
                        // ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Select All',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 24 * FCStyle.fem,
                              fontWeight: FontWeight.w700),
                        )
                      ]),
                ));
          }),
          const SizedBox(height: 10),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: widget.disabled
                      ? MaterialStatePropertyAll(
                          Color.fromARGB(223, 237, 236, 236))
                      : MaterialStatePropertyAll(
                          Color.fromARGB(255, 255, 255, 255))),
              onPressed: () {
                if (!widget.disabled) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FCConfirmDialog(
                          height: 400,
                          width: 660,
                          subText:
                              'This action will delete selected photos by you',
                          submitText: 'Confirm',
                          cancelText: 'Cancel',
                          icon: VitalIcons.deleteIcon,
                          message: CommonStrings.deleteConfirmationMessage.tr(),
                        );
                      }).then((value) {
                    if (value) {
                      context.read<MemoriesBloc>().add(const DeleteMemories());
                      context
                          .read<MemoriesBloc>()
                          .add(const CancelMediaToShare());
                    }
                  });
                } else {}
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                width: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(VitalIcons.deleteIconWithRing,
                        width: 18,
                        color: widget.disabled
                            ? Color.fromARGB(255, 86, 86, 86)
                            : Color.fromARGB(255, 150, 49, 9)),
                    SizedBox(
                      width: 17,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
                          color: widget.disabled
                              ? Color.fromARGB(255, 86, 86, 86)
                              : Color.fromARGB(255, 0, 0, 0),
                          fontSize: 25 * FCStyle.fem,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ))
          // actionButton(
          //     disabled: widget.disabled,
          //     buttonText: MemoriesStrings.delete.tr(),
          //     onClick: () {
          //       showDialog(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return FCConfirmDialog(
          //               message: CommonStrings.deleteConfirmationMessage.tr(),
          //             );
          //           }).then((value) {
          //         if (value) {
          //           context.read<MemoriesBloc>().add(const DeleteMemories());
          //           context
          //               .read<MemoriesBloc>()
          //               .add(const CancelMediaToShare());
          //         }
          //       });
          //     }),
          ,
          const SizedBox(height: 10),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: widget.disabled
                      ? MaterialStatePropertyAll(
                          Color.fromARGB(223, 237, 236, 236))
                      : MaterialStatePropertyAll(ColorPallet.kPrimary)),
              onPressed: () {
                if (!widget.disabled) {
                  if (_totalSelected > 6) {
                    FCAlert.showInfo("Only 6 photos can be shared at a time!!",
                        duration: const Duration(milliseconds: 1000));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FCConfirmDialog(
                            height: 400,
                            width: 660,
                            subText:
                                'This action will share selected photos by you',
                            submitText: 'Confirm',
                            cancelText: 'Cancel',
                            icon: VitalIcons.shareIconWithRing,
                            message: 'Are you sure you want to Share?',
                          );
                        }).then((value) {
                      if (value) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const SharePhotosPopup();
                          },
                        ).then((value) {
                          if (value != null && value) {
                            Navigator.pop(context);
                          }
                          //
                          // context
                          //     .read<FamilyMemberCubit>()
                          //     .resetSelectMemberToShareMedia();
                          // context
                          //     .read<MemoriesBloc>()
                          //     .add(ResetSelectedMemberToShareMedia());
                        });
                        //   context.read<MemoriesBloc>().add(const DeleteMemories());
                        //   context
                        //       .read<MemoriesBloc>()
                        //       .add(const CancelMediaToShare());
                      }
                    });
                  }
                } else {}
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 17),
                width: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    SvgPicture.asset(
                      VitalIcons.shareIcon,
                      color: widget.disabled
                          ? Color.fromARGB(255, 118, 118, 118)
                          : ColorPallet.kPrimaryText,
                      width: 23,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Share',
                      style: TextStyle(
                          color: widget.disabled
                              ? Color.fromARGB(255, 118, 118, 118)
                              : ColorPallet.kPrimaryText,
                          fontSize: 25 * FCStyle.fem,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              )),

          // actionButton(
          //     disabled: widget.disabled,
          //     buttonText: MemoriesStrings.share.tr(),
          //     onClick: () {
          //       showDialog(
          //         context: context,
          //         builder: (context) {
          //           return const SharePhotosPopup();
          //         },
          //       ).then((value) {
          //         if (value != null && value) {
          //           Navigator.pop(context);
          //         }
          //         //
          //         // context
          //         //     .read<FamilyMemberCubit>()
          //         //     .resetSelectMemberToShareMedia();
          //         // context
          //         //     .read<MemoriesBloc>()
          //         //     .add(ResetSelectedMemberToShareMedia());
          //       });
          //     }),

          // SizedBox(
          //   height: 30,
          // ),
          // actionButton(
          //     disabled: disabled,
          //     buttonText: MemoriesStrings.create.tr(),
          //     onClick: () {
          //       showDialog(
          //         context: context,
          //         builder: (context) {
          //           return CreateOptionPopup();
          //         },
          //       ).then((value) {
          //         if (value != null && value) {
          //           Navigator.pop(context);
          //         }
          //       });
          //     }),
          // SizedBox(
          //   height: 30,
          // ),
          // actionButton(
          //     disabled: disabled,
          //     buttonText: MemoriesStrings.move.tr(),
          //     onClick: () {
          //       showDialog(
          //         context: context,
          //         builder: (context) {
          //           return PhotosMoveToAlbumPopup();
          //         },
          //       ).then((value) {
          //         if (value != null && value) {
          //           Navigator.pop(context);
          //         }
          //       });
          //     }),
        ],
      ),
    );
  }

  Widget actionButton(
          {required String buttonText,
          required Function() onClick,
          required bool disabled}) =>
      FCPrimaryButton(
        width: FCStyle.blockSizeHorizontal * 7,
        defaultSize: false,
        fontWeight: FontWeight.bold,
        label: buttonText,
        labelColor: disabled ? ColorPallet.kDisabledColor : ColorPallet.kWhite,
        color:
            disabled ? ColorPallet.kCardBackground : ColorPallet.kBrightGreen,
        onPressed: !disabled ? onClick : () {},
      );

  showMedicationDetailsPopup({required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (context) {
        return const FCComingSoonPopup();
      },
    );
  }
}
