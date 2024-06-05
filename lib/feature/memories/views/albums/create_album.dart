import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:famici/core/blocs/auth_bloc/auth_bloc.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/memories/blocs/add_album/add_album_bloc.dart';
import 'package:famici/feature/memories/blocs/album_bloc/album_bloc.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/feature/memories/views/media/media_item.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/fc_text_form_field.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/famici.theme.dart';

import '../../../../core/enitity/user.dart';

class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({Key? key}) : super(key: key);

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  late final AddAlbumBloc _addAlbumBloc;

  @override
  void initState() {
    super.initState();
    _addAlbumBloc = AddAlbumBloc(me: Provider.of<User>(context, listen: false));
    context.read<MemoriesBloc>().add(ToggleSelectMediaToShare());
  }

  @override
  void deactivate() {
    context.read<MemoriesBloc>().add(ToggleSelectMediaToShare());
    super.deactivate();
  }

  @override
  void dispose() {
    _addAlbumBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FamiciScaffold(
      resizeOnKeyboard: true,
      leading: BlocBuilder(
        bloc: _addAlbumBloc,
        builder: (context, AddAlbumState state) {
          if (state.status == AddAlbumStatus.initial) {
            return FCBackButton(
              onPressed: () => Navigator.pop(context),
            );
          } else if (state.status == AddAlbumStatus.selectingPhotos) {
            return FCBackButton(onPressed: () {
              _addAlbumBloc.add(ShowAddAlbumTitle());
            });
          }

          return FCBackButton(
            onPressed: () {
              _addAlbumBloc.add(ShowSelectPhotos());
            },
          );
        },
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            MemoriesStrings.createNewAlbum.tr(),
            style: FCStyle.textStyle.copyWith(fontSize: FCStyle.largeFontSize),
          )
        ],
      ),
      trailing: FCMaterialButton(
        defaultSize: false,
        child: SizedBox(
            height: 100.h,
            width: 180.w,
            child: Center(
              child: Text(
                CommonStrings.cancel.tr(),
                style: FCStyle.textStyle.copyWith(
                  color: ColorPallet.kWhite,
                  fontSize: 36.sp,
                ),
              ),
            )),
        color: ColorPallet.kDarkRed,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
                height: FCStyle.xLargeFontSize,
                width: FCStyle.xLargeFontSize,
                child: LoadingScreen(),
              ),
            );
          } else if (state.status == AddAlbumStatus.initial) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
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
                              _addAlbumBloc.add(ValidateAlbumTitle(value));
                            },
                            textInputFormatters: [
                              LengthLimitingTextInputFormatter(25),
                              NoLeadingSpaceFormatter(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      bottom: FCStyle.blockSizeVertical * 3,
                      right: FCStyle.blockSizeHorizontal * 2),
                  alignment: Alignment.bottomRight,
                  child: NextButton(
                    hasIcon: true,
                    onPressed: () {
                      _addAlbumBloc.add(ShowSelectPhotos());
                    },
                  ),
                )
              ],
            );
          } else if (state.status == AddAlbumStatus.selectingPhotos) {
            return BlocBuilder<MemoriesBloc, MemoriesState>(
              builder: (context, MemoriesState memoriesState) {
                return Stack(
                  children: [
                    memoriesState.media.isNotEmpty
                        ? GridView.builder(
                            //key: UniqueKey(),
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 16.0,
                                    crossAxisSpacing: 16.0,
                                    childAspectRatio: 3 / 2),
                            itemCount: memoriesState.media.length,
                            padding: EdgeInsets.symmetric(
                              vertical: 24.0,
                              horizontal: 96.0,
                            ),
                            itemBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return MediaItem(
                                isSelectable: memoriesState.selectMediaToShare,
                                media: memoriesState.media[index],
                                onPressed: () {
                                  context.read<MemoriesBloc>().add(
                                        MediaSelected(
                                            memoriesState.media[index]),
                                      );
                                  _addAlbumBloc.add(
                                    ToggleSelectedStatusAlbumMemories(
                                        memoriesState.media[index]),
                                  );
                                },
                                onSelect: () {
                                  context.read<MemoriesBloc>().add(
                                        MediaSelected(
                                            memoriesState.media[index]),
                                      );
                                  _addAlbumBloc.add(
                                    ToggleSelectedStatusAlbumMemories(
                                        memoriesState.media[index]),
                                  );
                                },
                              );
                            })
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 64.0),
                              child: Text(
                                MemoriesStrings.youDontHaveAnyPhotos.tr(),
                                style: FCStyle.textStyle.copyWith(fontSize: 40),
                              ),
                            ),
                          ),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.all(32.0),
                      child: FCPrimaryButton(
                        defaultSize: true,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 32.0,
                        ),
                        width: 160,
                        onPressed: state.selectedMedia.isNotEmpty
                            ? () {
                                _addAlbumBloc.add(SaveAlbum());
                              }
                            : () {},
                        color: state.selectedMedia.isNotEmpty
                            ? ColorPallet.kGreen
                            : ColorPallet.kCardBackground,
                        labelColor: state.selectedMedia.isNotEmpty
                            ? ColorPallet.kBackButtonTextColor
                            : ColorPallet.kPrimaryTextColor.withOpacity(0.4),
                        fontSize: FCStyle.mediumFontSize,
                        fontWeight: FontWeight.bold,
                        label: CommonStrings.create.tr(),
                      ),
                    )
                  ],
                );
              },
            );
          }

          return Center(child: LoadingScreen());
        },
      ),
    );
  }
}
