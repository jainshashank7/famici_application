import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../core/enitity/user.dart';
import '../../../../core/router/router_delegate.dart';
import '../../../../shared/fc_back_button.dart';

class SharePhotosPopup extends StatefulWidget {
  const SharePhotosPopup({Key? key}) : super(key: key);

  @override
  _SharePhotosPopupState createState() => _SharePhotosPopupState();
}

class _SharePhotosPopupState extends State<SharePhotosPopup> {
  @override
  void initState() {
    context.read<MemoriesBloc>().add(ShareMediaWithMember());
    context.read<MemoriesBloc>().add(CancelMediaToShare());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorPallet.kDarkBackGround,
          body: Container(
            color: ColorPallet.kBackground,
            margin: EdgeInsets.all(32.0),
            child: Center(
              child: BlocBuilder<MemoriesBloc, MemoriesState>(
                builder: (context, MemoriesState memoriesState) {
                  if (memoriesState.status == Status.loading) {
                    return CircularProgressIndicator();
                  }
                  if (memoriesState.requestStatus == Status.success) {
                    return _RequestMediaSuccess();
                  }
                  if (memoriesState.requestStatus == Status.initial) {
                    return _SharePhotosDetailsForm();
                  }
                  if (memoriesState.requestStatus == Status.failure) {
                    return _ErrorMessagePopup();
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorMessagePopup extends StatelessWidget {
  const _ErrorMessagePopup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPallet.kDarkRed,
            ),
            padding: EdgeInsets.all(12.0),
            child: Icon(
              Icons.close,
              color: ColorPallet.kLightBackGround,
              size: 64,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 48.0),
            child: Text(
              "Unable to communicate with the server!\n Please try again later.",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: FCStyle.textStyle.copyWith(
                fontSize: FCStyle.mediumFontSize,
              ),
            ),
          ),
          FCBackButton(
            onPressed: () {
              context
                  .read<MemoriesBloc>()
                  .add(ResetSelectedMemberToShareMedia());
              Navigator.pop(context);
            },
            label: CommonStrings.back.tr(),
          )
        ],
      ),
    );
  }
}

class _SharePhotosDetailsForm extends StatelessWidget {
  const _SharePhotosDetailsForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ListView(
        //   shrinkWrap: true,
        Stack(
          children: [
            // Container(
            //   margin: EdgeInsets.only(top: 32.0),
            //   alignment: Alignment.topCenter,
            //   child: Text(
            //     MemoriesStrings.whoDoYouWantToSharePhotosWith.tr(),
            //     style: TextStyle(
            //       color: ColorPallet.kPrimaryTextColor,
            //       fontSize: FCStyle.largeFontSize,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // BlocBuilder<FamilyMemberCubit, FamilyMemberState>(
            //   builder: (context, FamilyMemberState state) {
            //     if (state.status == FamilyBlocStatus.loading) {
            //       return Container(
            //         alignment: Alignment.center,
            //         margin: EdgeInsets.only(top: 48.0),
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //     if (state.existingMembers.isEmpty) {
            //       return Container(
            //         padding: EdgeInsets.symmetric(vertical: 100),
            //         margin: EdgeInsets.only(top: 32.0),
            //         alignment: Alignment.center,
            //         child: Text(
            //           CommonStrings.noMembersFound.tr(),
            //           style: TextStyle(
            //             color: ColorPallet.kPrimaryTextColor,
            //             fontSize: FCStyle.largeFontSize,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       );
            //     }
            //
            //     List<User> members = List.from(state.existingMembers);
            //     members.removeWhere((user) => user.isCareGiver);
            //
            //     return Container(
            //       alignment: Alignment.center,
            //       width: MediaQuery.of(context).size.width,
            //       height: 300,
            //       margin: EdgeInsets.only(top: 64.0),
            //       child: ListView.builder(
            //         itemCount: members.length,
            //         shrinkWrap: true,
            //         physics: BouncingScrollPhysics(),
            //         scrollDirection: Axis.horizontal,
            //         itemBuilder: (BuildContext context, int index) {
            //           return UserAvatar(
            //             onTap: () {
            //               context
            //                   .read<FamilyMemberCubit>()
            //                   .selectMemberToShareMedia(
            //                 user: members[index],
            //               );
            //               context.read<MemoriesBloc>().add(
            //                 SelectMemberToShareMedia(
            //                   members[index],
            //                 ),
            //               );
            //             },
            //             user: members[index],
            //             showName: true,
            //             margin: EdgeInsets.symmetric(
            //               vertical: 8.0,
            //               horizontal: 24.0,
            //             ),
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 24.0),
            //   child: Column(
            //     children: [
            //       SizedBox(
            //         width: MediaQuery.of(context).size.width * 2 / 3,
            //         child: FCTextFormField(
            //           minLines: 3,
            //           maxLines: 3,
            //           hintText: MemoriesStrings.sharingPicturesWithYou.tr(),
            //           textInputAction: TextInputAction.done,
            //           onChanged: (val) {},
            //           textInputFormatters:  [LengthLimitingTextInputFormatter(100)],
            //         ),
            //       ),
            //       SizedBox(height: 24.0),
            //       BlocBuilder<MemoriesBloc, MemoriesState>(
            //         builder: (context, MemoriesState state) {
            //           return FCPrimaryButton(
            //             defaultSize: false,
            //             padding: EdgeInsets.symmetric(
            //               vertical: 20.0,
            //               horizontal: 32.0,
            //             ),
            //             width: 160,
            //             onPressed: state.selectedMembersToShareMedia.isNotEmpty
            //                 ? () {
            //               context
            //                   .read<MemoriesBloc>()
            //                   .add(ShareMediaWithMember());
            //               context
            //                   .read<MemoriesBloc>()
            //                   .add(CancelMediaToShare());
            //             }
            //                 : () {},
            //             color: state.selectedMembersToShareMedia.isNotEmpty
            //                 ? ColorPallet.kGreen
            //                 : ColorPallet.kLightBackGround,
            //             labelColor: state.selectedMembersToShareMedia.isNotEmpty
            //                 ? ColorPallet.kBackButtonTextColor
            //                 : ColorPallet.kGrey.withOpacity(0.4),
            //             fontSize: FCStyle.mediumFontSize,
            //             fontWeight: FontWeight.bold,
            //             label: MemoriesStrings.share.tr(),
            //           );
            //         },
            //       )
            //     ],
            //   ),
            // ),
            Align(
              alignment: Alignment.center,
              child: BlocBuilder<MemoriesBloc, MemoriesState>(
                builder: (context, MemoriesState state) {
                  return FCPrimaryButton(
                    defaultSize: false,
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 32.0,
                    ),
                    width: 160,
                    onPressed: () {
                      context.read<MemoriesBloc>().add(ShareMediaWithMember());
                      context.read<MemoriesBloc>().add(CancelMediaToShare());
                    },
                    color: ColorPallet.kGreen,
                    labelColor: ColorPallet.kBackButtonTextColor,
                    fontSize: FCStyle.mediumFontSize,
                    fontWeight: FontWeight.bold,
                    label: MemoriesStrings.share.tr(),
                  );
                },
              ),
            )
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
                  context
                      .read<MemoriesBloc>()
                      .add(ResetSelectedMemberToShareMedia());
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

class _RequestMediaSuccess extends StatelessWidget {
  const _RequestMediaSuccess({
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
            MemoriesStrings.youHaveSentPhotosToShare.tr(),
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
            context.read<MemoriesBloc>().add(CancelMediaToShare());
            context.read<MemoriesBloc>().add(ShareMediaSuccess());
            context.read<MemoriesBloc>().add(ResetSelectedMemberToShareMedia());
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
