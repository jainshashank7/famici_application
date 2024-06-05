import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/chat/blocs/sigle_user_chat/single_user_chat_bloc.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/utils/barrel.dart';

import '../../audio_player/waveform_audio_player.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    this.isLatest = false,
    required this.message,
    required this.username,
    this.userId,
    this.onPressed,
    this.showTopDate = false,
  }) : super(key: key);

  final bool isLatest;
  final Message message;
  final String? userId;
  final ValueChanged<Message>? onPressed;
  final bool showTopDate;
  final String username;

  bool get isMe => userId == message.sentBy;

  bool isCalledByMe(String? id) => id != null && userId == id;

  Widget get content {
    if (message.isText) {
      return Container(
        constraints: BoxConstraints(minWidth: FCStyle.xLargeFontSize * 6 + 16),
        child: Text(
          message.text,
          style: FCStyle.textStyle,
        ),
      );
    } else if (message.isAudio) {
      return WaveformAudioPlayer(
        audioUrl:
            message.data.local.isEmpty ? message.data.url : message.data.local,
      );
    } else if (message.isImage) {
      if (message.data.local.isNotEmpty) {
        Container(
          constraints: BoxConstraints(
            minWidth: FCStyle.xLargeFontSize * 6,
            minHeight: FCStyle.xLargeFontSize * 6,
          ),
          child: Image.file(
            File(message.data.local),
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Container(
          constraints: BoxConstraints(
            minWidth: FCStyle.xLargeFontSize * 6,
            minHeight: FCStyle.xLargeFontSize * 6,
          ),
          child: Center(
            child: CachedNetworkImage(
              imageUrl: message.data.url,
              progressIndicatorBuilder: (context, url, progress) {
                return CupertinoActivityIndicator();
              },
              errorWidget: (ctx, url, err) {
                return Icon(
                  Icons.broken_image_rounded,
                  color: ColorPallet.kPrimaryTextColor,
                );
              },
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
    return SizedBox.shrink();
  }

  Widget getDate() {
    String _formatted = DateFormat(dateFormat).format(message.createdAt);
    String _now = DateFormat(dateFormat).format(DateTime.now());
    if (!showTopDate) {
      return SizedBox.shrink();
    } else if (_formatted == _now) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Today',
          style: FCStyle.textStyle,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          _formatted,
          style: FCStyle.textStyle,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getDate(),
        message.isCallReceipt
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Text(
                      DateFormat(time12hFormat).format(message.createdAt),
                      textAlign: TextAlign.center,
                      style: FCStyle.textStyle,
                    ),
                    Text(
                      isCalledByMe(message.data.caller)
                          ? message.data.callerTitle
                          : message.data.calleeTitle,
                      textAlign: TextAlign.center,
                      style: FCStyle.textStyle,
                    ),
                    if (message.data.body.isNotEmpty &&
                        isCalledByMe(message.data.caller))
                      Text(
                        message.data.body,
                        textAlign: TextAlign.center,
                        style: FCStyle.textStyle,
                      ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: isMe
                          ? EdgeInsets.only(left: FCStyle.xLargeFontSize * 3)
                          : EdgeInsets.only(right: FCStyle.xLargeFontSize * 3),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        padding: EdgeInsets.all(20 * FCStyle.fem),
                        decoration: BoxDecoration(
                          color: ColorPallet.kWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(60 * FCStyle.fem),
                            bottomRight: Radius.circular(60 * FCStyle.fem),
                            bottomLeft: Radius.circular(40 * FCStyle.fem),

                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<SingleUserChatBloc,
                                    SingleUserChatState>(
                                  builder: (context, userChatState) {
                                    return SizedBox(
                                      width: FCStyle.xLargeFontSize * 4,
                                      child: Text(
                                        isMe
                                            ? ConnectStrings.youSaid.tr()
                                            :  username +
                                                ConnectStrings.userSays.tr(
                                                    args: [
                                                      userChatState.contact
                                                              .givenName ??
                                                          ''
                                                    ]),
                                        style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 24 * FCStyle.ffem
                                        ),
                                        overflow: TextOverflow.ellipsis,

                                        softWrap: false,
                                      ),
                                    );
                                  },
                                ),
                                Opacity(
                                  opacity: 0,
                                  child: content,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    message.receipt == Receipt.sent && isMe
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: Icon(
                                              Icons.watch_later_outlined,
                                              size: FCStyle.defaultFontSize,
                                              color: ColorPallet
                                                  .kPrimaryTextColor,
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    Text(
                                      DateFormat()
                                          .add_jm()
                                          .format(message.createdAt),
                                      style: FCStyle.textStyle
                                          .copyWith(height: 1.0),
                                    ),
                                  ],
                                ),
                                Opacity(
                                  opacity: 0,
                                  child: content,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 32, left: 10 * FCStyle.fem),
                              child: content,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
