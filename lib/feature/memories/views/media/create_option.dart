import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../core/enitity/user.dart';
import '../../blocs/add_album/add_album_bloc.dart';
import '../../blocs/album_bloc/album_bloc.dart';

class CreateOptionPopup extends StatefulWidget {
  const CreateOptionPopup({Key? key}) : super(key: key);

  @override
  _CreateOptionPopupState createState() => _CreateOptionPopupState();
}

class _CreateOptionPopupState extends State<CreateOptionPopup> {
  late final AddAlbumBloc _addAlbumBloc;
  @override
  void initState() {
    super.initState();
    _addAlbumBloc = AddAlbumBloc(me: Provider.of<User>(context, listen: false));
  }

  @override
  void dispose() {
    _addAlbumBloc.close();
    super.dispose();
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
              child: BlocConsumer(
                listener: (BuildContext context, AddAlbumState addAlbumState) {
                  if (addAlbumState.status == AddAlbumStatus.success) {
                    context.read<AlbumBloc>().add(FetchInitialAlbums());
                  }
                },
                bloc: _addAlbumBloc,
                builder: (context, AddAlbumState state) {
                  if (state.status == AddAlbumStatus.success) {
                    return _AlbumCreateSuccess();
                  }
                  if (state.status == AddAlbumStatus.initial) {
                    return _CreateOptionDetailsForm(
                      addAlbumBloc: _addAlbumBloc,
                    );
                  }
                  if (state.status == AddAlbumStatus.failure) {
                    return Icon(Icons.close);
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

class _CreateOptionDetailsForm extends StatelessWidget {
  const _CreateOptionDetailsForm({
    Key? key,
    required this.addAlbumBloc,
  }) : super(key: key);

  final AddAlbumBloc addAlbumBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoriesBloc, MemoriesState>(
      builder: (context, memoriesState) {
        return Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 32.0, bottom: 50),
                  alignment: Alignment.topCenter,
                  child: Text(
                    MemoriesStrings.createAlbum.tr(),
                    style: TextStyle(
                      color: ColorPallet.kPrimaryTextColor,
                      fontSize: FCStyle.largeFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    BlocConsumer(
                      listener:
                          (BuildContext context, AddAlbumState addAlbumState) {
                        if (addAlbumState.status == AddAlbumStatus.success) {
                          context.read<AlbumBloc>().add(FetchInitialAlbums());
                          Navigator.pop(context);
                        }
                      },
                      bloc: addAlbumBloc,
                      builder: (context, AddAlbumState state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                MemoriesStrings.addATitle.tr(),
                                style: FCStyle.textStyle.copyWith(
                                  fontSize: FCStyle.largeFontSize,
                                ),
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
                                  addAlbumBloc.add(ValidateAlbumTitle(value));
                                },
                                textInputFormatters: [
                                  LengthLimitingTextInputFormatter(25),
                                  NoLeadingSpaceFormatter(),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
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
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: FCStyle.blockSizeVertical * 3,
                    right: FCStyle.blockSizeHorizontal * 2),
                alignment: Alignment.bottomRight,
                child: NextButton(
                  label: MemoriesStrings.save.tr(),
                  hasIcon: false,
                  onPressed: () {
                    addAlbumBloc.add(
                        ValidateAlbumTitle(addAlbumBloc.state.title.value));
                    if (addAlbumBloc.state.title.valid) {
                      addAlbumBloc.add(FetchSelectedMediaFromCreateOption(
                          memoriesState.media));
                      addAlbumBloc.add(SaveAlbum());
                    }
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _AlbumCreateSuccess extends StatelessWidget {
  const _AlbumCreateSuccess({
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
            MemoriesStrings.albumCreateSuccess.tr(),
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
