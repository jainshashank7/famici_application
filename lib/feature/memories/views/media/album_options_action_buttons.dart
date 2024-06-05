import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:famici/feature/memories/blocs/album_bloc/album_bloc.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/feature/memories/views/albums/edit_album_popup.dart';
import 'package:famici/feature/memories/views/media/share_photos_popup.dart';
import 'package:famici/shared/fc_coming_soon_popup.dart';
import 'package:famici/shared/fc_confirm_dialog.dart';
import 'package:famici/shared/fc_primary_button.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/memories_strings.dart';

class AlbumOptionsActionButtons extends StatelessWidget {
  const AlbumOptionsActionButtons({Key? key, required this.disabled})
      : super(key: key);
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          actionButton(
              disabled: disabled,
              buttonText: MemoriesStrings.delete.tr(),
              onClick: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return FCConfirmDialog(
                        message: CommonStrings.deleteConfirmationMessage.tr(),
                      );
                    }).then((value) {
                  if (value) {
                    context.read<AlbumBloc>().add(DeleteAlbum());
                    context.read<AlbumBloc>().add(CancelAlbumToOptions());
                  }
                });
              }),
          SizedBox(
            height: 30,
          ),
          actionButton(
              disabled: disabled,
              buttonText: MemoriesStrings.update.tr(),
              onClick: () {
                _showEditAlbumPopup(context: context);
              }),
        ],
      ),
    );
  }

  Widget actionButton({
    required String buttonText,
    required Function() onClick,
    required bool disabled,
  }) =>
      FCPrimaryButton(
        width: 110,
        defaultSize: false,
        fontWeight: FontWeight.bold,
        label: buttonText,
        labelColor: disabled ? ColorPallet.kDisabledColor : ColorPallet.kWhite,
        color:
            disabled ? ColorPallet.kCardBackground : ColorPallet.kBrightGreen,
        onPressed: !disabled ? onClick : () {},
      );

  _showEditAlbumPopup({required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (context) {
        return EditAlbumPopup();
      },
    );
  }
}
