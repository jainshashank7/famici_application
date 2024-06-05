import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/memories/entities/album.dart';
import 'package:famici/shared/barrel.dart';

import '../../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../../core/enitity/user.dart';
import '../../../../utils/config/color_pallet.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../../utils/strings/common_strings.dart';
import '../../../../utils/strings/memories_strings.dart';
import '../../blocs/add_album/add_album_bloc.dart';
import '../../blocs/album_bloc/album_bloc.dart';
import '../../blocs/memories/memories_bloc.dart';
import '../media/media_item.dart';

class EditAlbumPopup extends StatefulWidget {
  const EditAlbumPopup({Key? key, this.album}) : super(key: key);
  final Album? album;
  @override
  State<EditAlbumPopup> createState() => _EditAlbumPopupState();
}

class _EditAlbumPopupState extends State<EditAlbumPopup> {
  late AddAlbumBloc _addAlbumBloc;
  @override
  void initState() {
    super.initState();
    _addAlbumBloc = AddAlbumBloc(
      me: Provider.of<User>(context, listen: false),
      album: context.read<AlbumBloc>().state.selectedAlbum,
    );
    context.read<MemoriesBloc>().add(ToggleSelectMediaToShare());
  }

  @override
  void deactivate() {
    context.read<MemoriesBloc>().add(ToggleSelectMediaToShare());
    _addAlbumBloc.close();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return PopupScaffold(
      resizeToAvoidBottomInset: true,
      child: BlocConsumer(
        listener: (BuildContext context, AddAlbumState addAlbumState) {
          if (addAlbumState.status == AddAlbumStatus.success) {
            context.read<AlbumBloc>().add(FetchInitialAlbums());
            Navigator.pop(context);
          }
        },
        bloc: _addAlbumBloc,
        builder: (context, AddAlbumState state) {
          if (state.status == AddAlbumStatus.loading) {
            return Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: LoadingScreen(),
              ),
            );
          } else if (state.status == AddAlbumStatus.initial) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  // physics: BouncingScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 3 / 4,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Text(
                            MemoriesStrings.editAlbumTitle.tr(),
                            style: FCStyle.textStyle.copyWith(
                                fontSize: FCStyle.largeFontSize,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 600,
                            minWidth: 300,
                          ),
                          child: FCTextFormField(
                            keyboardType: TextInputType.name,
                            hasError: state.title.invalid,
                            error: state.title.error?.message,
                            initialValue: state.title.value,
                            onChanged: (value) {
                              _addAlbumBloc.add(ValidateAlbumTitle(value));
                            },
                            textInputFormatters: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: FCStyle.blockSizeVertical * 7,
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(
                              bottom: FCStyle.blockSizeVertical * 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NextButton(
                                hasIcon: false,
                                label: CommonStrings.cancel.tr(),
                                color: ColorPallet.kDarkRed,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: FCStyle.blockSizeHorizontal * 3,
                              ),
                              NextButton(
                                hasIcon: false,
                                label: MemoriesStrings.save.tr(),
                                onPressed: () {
                                  List<Album> _existingList =
                                      context.read<AlbumBloc>().state.albums;
                                  int index = _existingList
                                      .indexWhere((album) => album.isSelected);
                                  _addAlbumBloc.add(SaveEditedAlbumTitle(
                                      _existingList[index]));
                                  context
                                      .read<AlbumBloc>()
                                      .add(CancelAlbumToOptions());
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, top: 30),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close,
                          color: ColorPallet.kPrimaryTextColor, size: 70),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Container(
              child: LoadingScreen(),
              width: FCStyle.largeFontSize,
              height: FCStyle.largeFontSize,
              alignment: Alignment.center,
            ),
          );
        },
      ),
    );
  }
}
