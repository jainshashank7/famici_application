import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/connect_with_family/blocs/family_member/family_member_cubit.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/feature/memories/models/request_note_input.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

class RequestMemoriesPopup extends StatefulWidget {
  const RequestMemoriesPopup({Key? key}) : super(key: key);

  @override
  _RequestMemoriesPopupState createState() => _RequestMemoriesPopupState();
}

class _RequestMemoriesPopupState extends State<RequestMemoriesPopup> {
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
                  if (memoriesState.requestStatus == Status.success) {
                    return _RequestMediaSuccess();
                  }
                  if (memoriesState.requestStatus == Status.initial) {
                    return _RequestMediaDetailsForm();
                  }
                  if (memoriesState.requestStatus == Status.failure) {
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

class _RequestMediaDetailsForm extends StatefulWidget {
  const _RequestMediaDetailsForm({
    Key? key,
  }) : super(key: key);

  @override
  State<_RequestMediaDetailsForm> createState() =>
      _RequestMediaDetailsFormState();
}

class _RequestMediaDetailsFormState extends State<_RequestMediaDetailsForm> {
  final TextEditingController _noteController = TextEditingController();
  NoteInput _noteInput = NoteInput.pure();
  bool isInitial = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _noteController.addListener(() {
      setState(() {
        _noteInput = NoteInput.pure(value: _noteController.text);
        if (!isInitial) {
          _noteInput = NoteInput.dirty(value: _noteController.text);
        } else if (_noteController.text.isNotEmpty) {
          _noteInput = NoteInput.dirty(value: _noteController.text);
          isInitial = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.only(top: 32.0),
              alignment: Alignment.topCenter,
              child: Text(
                MemoriesStrings.whoDoYouWantToRequest.tr(),
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.largeFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<FamilyMemberCubit, FamilyMemberState>(
              builder: (context, FamilyMemberState state) {
                if (state.status == FamilyBlocStatus.loading) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: FCStyle.largeFontSize),
                    child: Center(child: LoadingScreen()),
                  );
                }

                List<User> members = List.from(state.existingMembers);
                members.removeWhere((user) => user.isCareGiver);

                return Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: FCStyle.xLargeFontSize * 6,
                  margin: EdgeInsets.only(top: FCStyle.largeFontSize),
                  child: ShaderMask(
                    shaderCallback: (Rect rect) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          ColorPallet.kBackground,
                          Colors.transparent,
                          Colors.transparent,
                          ColorPallet.kBackground,
                        ],
                        stops: [0.0, 0.2, 0.8, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: AnimationLimiter(
                      child: ListView.builder(
                        itemCount: members.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            delay: Duration(milliseconds: 100),
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              horizontalOffset: 100.0,
                              child: FadeInAnimation(
                                child: UserAvatar(
                                  height: FCStyle.xLargeFontSize * 3,
                                  width: FCStyle.xLargeFontSize * 3,
                                  onTap: () {
                                    context
                                        .read<FamilyMemberCubit>()
                                        .selectMemberToRequestMedia(
                                          user: members[index],
                                        );
                                    context.read<MemoriesBloc>().add(
                                          ToggleSelectedMemberToRequestMedia(
                                            members[index],
                                          ),
                                        );
                                  },
                                  user: members[index],
                                  showName: true,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 2 / 3,
                    child: FCTextFormField(
                      textEditingController: _noteController,
                      hasError: _noteInput.invalid,
                      error: _noteInput.error?.message,
                      minLines: 3,
                      maxLines: 3,
                      hintText:
                          MemoriesStrings.wouldYouShareWithMePictures.tr(),
                      textInputAction: TextInputAction.done,
                      textInputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                        NoLeadingSpaceFormatter()
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0),
                  BlocBuilder<MemoriesBloc, MemoriesState>(
                    builder: (context, MemoriesState state) {
                      return FCPrimaryButton(
                        defaultSize: false,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 32.0,
                        ),
                        width: 160,
                        onPressed:
                            state.selectedMembersToRequestMedia.isNotEmpty &&
                                    _noteInput.valid &&
                                    !_noteInput.pure
                                ? () {
                                    context.read<MemoriesBloc>().add(
                                          RequestMediaFromMember(
                                            _noteController.text,
                                          ),
                                        );
                                  }
                                : () {
                                    setState(() {
                                      _noteInput = NoteInput.dirty(
                                        value: _noteController.text,
                                      );
                                    });
                                  },
                        color: state.selectedMembersToRequestMedia.isNotEmpty &&
                                _noteInput.valid &&
                                !_noteInput.pure
                            ? ColorPallet.kGreen
                            : ColorPallet.kLightBackGround,
                        labelColor:
                            state.selectedMembersToRequestMedia.isNotEmpty &&
                                    _noteInput.valid &&
                                    !_noteInput.pure
                                ? ColorPallet.kBackButtonTextColor
                                : ColorPallet.kGrey.withOpacity(0.4),
                        fontSize: FCStyle.mediumFontSize,
                        fontWeight: FontWeight.bold,
                        label: MemoriesStrings.request.tr(),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CloseIconButton(
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
            MemoriesStrings.aRequestHasBeenSentToYourFamilyMembers.tr(),
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
            Navigator.pop(context, true);
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
