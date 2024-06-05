import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/enitity/barrel.dart';

import '../../../shared/concave_card.dart';
import '../../../utils/barrel.dart';
import '../blocs/sigle_user_chat/single_user_chat_bloc.dart';

class ChatTitleToolbar extends StatelessWidget {
  const ChatTitleToolbar({
    Key? key,
  }) : super(key: key);

  Text statusIndicator(User user) {
    return Text(
      user.isOnline ? 'Online' : 'Offline',
      style: FCStyle.textStyle.copyWith(
        fontSize: FCStyle.defaultFontSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocBuilder<SingleUserChatBloc, SingleUserChatState>(
        builder: (context, userState) {
          return SizedBox(
            width: FCStyle.screenWidth - 96,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(width: FCStyle.largeFontSize * 4),
                // NeumorphicButton(
                //   minDistance: 3,
                //   style: FCStyle.buttonCardStyle.copyWith(
                //     boxShape: NeumorphicBoxShape.roundRect(
                //       const BorderRadius.only(
                //         bottomLeft: Radius.circular(16),
                //         bottomRight: Radius.circular(16),
                //       ),
                //     ),
                //     border: NeumorphicBorder(
                //       color: ColorPallet.kCardDropShadowColor,
                //       width: 1,
                //     ),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //         left: 16.0, bottom: 24.0, top: 8.0,right:200),
                //     child: Text(
                //       "Murali",
                //       style: TextStyle(
                //           fontSize: FCStyle.largeFontSize,
                //           fontWeight: FontWeight.bold,
                //           color: ColorPallet.kPrimaryColor),
                //     ),
                //   ),
                // ),
                Spacer(),
                SizedBox(
                  //width: FCStyle.xLargeFontSize * 12,
                  height: FCStyle.mediumFontSize * 4,
                  child: ConcaveCard(
                    inverse: true,
                    depth: 3,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24.0),
                      bottomRight: Radius.circular(24.0),
                    ),
                    child: Row(
                      children: [
                        PhysicalModel(
                          color: Colors.transparent,
                          shadowColor: ColorPallet.kBlack,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24.0),
                            bottomRight: Radius.circular(24.0),
                          ),
                          elevation: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24.0),
                              bottomRight: Radius.circular(24.0),
                            ),
                            child: Container(
                              width: FCStyle.largeFontSize * 4,
                              height: FCStyle.mediumFontSize * 4,
                              decoration: BoxDecoration(
                                color: ColorPallet.kBackground,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: userState.contact.profileUrl ?? '',
                                imageBuilder: (context, image) => Container(
                                  width: FCStyle.largeFontSize * 4,
                                  height: FCStyle.mediumFontSize * 4,
                                  decoration: BoxDecoration(
                                    color: ColorPallet.kBackground,
                                    image: DecorationImage(
                                      image: image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, err) => Image.asset(
                                  AssetIconPath.userAvatar,
                                ),
                                progressIndicatorBuilder:
                                    (context, url, progress) => Image.asset(
                                  AssetIconPath.userAvatar,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         '${userState.contact.name}',
                        //         style: FCStyle.textStyle.copyWith(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: FCStyle.mediumFontSize,
                        //         ),
                        //       ),
                        //       BlocBuilder<UserDbBloc, UserDbState>(
                        //         builder: (context, state) {
                        //           User user =
                        //               state.fcUsers[userState.contact.id] ??
                        //                   User();
                        //
                        //           return statusIndicator(user);
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                // FCMaterialButton(
                //   borderRadius: BorderRadius.only(
                //     bottomLeft: Radius.circular(16.0),
                //     bottomRight: Radius.circular(16.0),
                //   ),
                //   color: ColorPallet.kCardBackground,
                //   onPressed: () {
                //     context.read<CallBloc>().add(CreateCall(userState.contact));
                //   },
                //   child: Image.asset(
                //     AssetIconPath.videoIcon,
                //     height: FCStyle.defaultFontSize * 3,
                //     width: FCStyle.mediumFontSize * 3,
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
