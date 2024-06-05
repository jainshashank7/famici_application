import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/medication_type.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/widgets/add_medication_failed_popup.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/widgets/add_medication_success_popup.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/widgets/add_medication_widgets.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/widgets/edit_medication_failed_popup.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/widgets/edit_medication_success_popup.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/calendar_set_dosage_duration.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/medication_buttons.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/shared/famici_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:famici/utils/strings/medication_strings.dart';

import '../../../../../core/blocs/auth_bloc/auth_bloc.dart';
import '../../../../../core/router/router_delegate.dart';
import '../../blocs/medication_bloc.dart';
import '../blocs/add_medication/add_medication_bloc.dart';

part 'sub_screens/medication_safety_disclaimer.dart';
part 'sub_screens/set_additional_details.dart';
part 'sub_screens/set_dosage_details.dart';
part 'sub_screens/set_frequency_and_quantity.dart';
part 'sub_screens/set_medication_duration.dart';
part 'sub_screens/set_medication_name_and_type.dart';
part 'sub_screens/view_medication_summary.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen(
      {Key? key, this.fromEditing = false, this.medicationStateForEditing})
      : super(key: key);

  final bool fromEditing;
  final MedicationState? medicationStateForEditing;

  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  late AddMedicationBloc _addMedicationBloc;

  @override
  void initState() {
    _addMedicationBloc = AddMedicationBloc(context.read<AuthBloc>());
    _addMedicationBloc.add(OnFetchMedicationSafetyDisclaimer());
    super.initState();
    if (widget.fromEditing) {
      _addMedicationBloc
          .add(SetDataForEditMedication(widget.medicationStateForEditing!));
      _addMedicationBloc.add(ToggleEditMedication(true));
    }
  }

  @override
  void dispose() {
    // if (_addMedicationBloc.state.isEditing) {
    //   _addMedicationBloc.add(ToggleEditMedication(false));
    // }
    _addMedicationBloc.close();
    super.dispose();
  }

  Future<void> showEditSuccessFailedDialog(
    BuildContext context,
    bool isSuccess,
  ) async {
    if (isSuccess) {
      return showDialog(
          context: context,
          builder: (context) {
            return EditMedicationSuccessPopup();
          });
    }
    return showDialog(
        context: context,
        builder: (context) {
          return EditMedicationFailedPopup();
        });
  }

  Future<void> showAddSuccessFailedDialog(
    BuildContext context,
    bool isSuccess,
  ) async {
    if (isSuccess) {
      return showDialog(
          context: context,
          builder: (context) {
            return AddMedicationSuccessPopup();
          });
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AddMedicationFailedPopup();
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addMedicationBloc,
      child: BlocConsumer(
          bloc: _addMedicationBloc,
          listener: (context, AddMedicationState state) {
            if (state.status == MedicationFormStatus.success) {
              context.read<MedicationBloc>().add(FetchMedications());
              Navigator.pop(context);
              if (state.isEditing) {
                Navigator.pop(context);
                showEditSuccessFailedDialog(context, true);
              } else {
                showAddSuccessFailedDialog(context, true);
              }
            }
            if (state.status == MedicationFormStatus.failure) {
              if (state.isEditing) {
                Navigator.pop(context);
                showEditSuccessFailedDialog(context, false);
              } else {
                showAddSuccessFailedDialog(context, false);
              }
            }
          },
          builder:
              (BuildContext context, AddMedicationState addMedicationState) {
            return FamiciScaffold(
              resizeOnKeyboard: true,
              title: Center(
                child: Text(
                  addMedicationState.isEditing
                      ? MedicationStrings.editMedications.tr()
                      : MedicationStrings.addANewMedicationTitle.tr(),
                  style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontSize: FCStyle.largeFontSize,
                  ),
                ),
              ),
              trailing: FCMaterialButton(
                color: ColorPallet.kDarkRed,
                child: SizedBox(
                  width: 160.w,
                  child: Center(
                    child: Text(
                      CommonStrings.cancel.tr(),
                      style: FCStyle.textStyle.copyWith(
                        color: ColorPallet.kWhite,
                        fontSize: 34.sp,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FCConfirmDialog();
                      }).then((value) {
                    if (value) {
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              leading: Row(
                children: [
                  FCBackButton(
                    iconData: Icons.arrow_back_ios,
                    label: CommonStrings.back.tr(),
                    onPressed: addMedicationState.currentStep >
                            addMedicationState.startStep + 1
                        ? () {
                            _addMedicationBloc.add(MedicationPreviousStep());
                          }
                        : () {
                            Navigator.pop(context);
                          },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  NeumorphicButton(
                    onPressed: () {
                      fcRouter.replaceAll([HomeRoute()]);
                    },
                    margin: EdgeInsets.all(2),
                    style: FCStyle.buttonCardStyle.copyWith(
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.all(Radius.circular(15)),
                      ),
                      border: NeumorphicBorder(
                        color: ColorPallet.kCardDropShadowColor,
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Image.asset(AssetIconPath.home),
                  )
                ],
              ),
              child: Stack(
                children: [
                  MedicationStepView(
                    addMedicationState: addMedicationState,
                    addMedBloc: _addMedicationBloc,
                  ),
                  BlocBuilder<AddMedicationBloc, AddMedicationState>(
                    builder: (context, addMedicineState) {
                      return MedicationButtons().nextButton(
                        disabled: addMedicineState.currentStep == 0 &&
                            !addMedicineState.safetyDisclaimerAccepted,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _addMedicationBloc.add(MedicationNextStep());
                        },
                        buttonText: addMedicationState.currentStep == 5
                            ? CommonStrings.done.tr()
                            : null,
                      );
                    },
                  )
                ],
              ),
            );
          }),
    );
  }
}

class MedicationStepView extends StatelessWidget {
  const MedicationStepView({
    Key? key,
    required this.addMedicationState,
    required this.addMedBloc,
  }) : super(key: key);

  final AddMedicationState addMedicationState;
  final AddMedicationBloc addMedBloc;

  @override
  Widget build(BuildContext context) {
    if (addMedicationState.showLoading || addMedicationState.isLoading) {
      return Center(
        child: SizedBox(
          width: FCStyle.xLargeFontSize,
          height: FCStyle.xLargeFontSize,
          child: LoadingScreen(),
        ),
      );
    } else if (addMedicationState.currentStep == 0) {
      return MedicationSafetyDisclaimer(addMedicationBloc: addMedBloc);
    } else if (addMedicationState.currentStep == 1) {
      return SetMedicationNameAndType(addMedicationBloc: addMedBloc);
    } else if (addMedicationState.currentStep == 2) {
      return SetFrequencyAndQuantity(addMedicationBloc: addMedBloc);
    } else if (addMedicationState.currentStep == 3) {
      return SetDosageDetails(addMedicationBloc: addMedBloc);
    } else if (addMedicationState.currentStep == 4) {
      return SetMedicationAdditionalDetails(addMedicationBloc: addMedBloc);
    } else if (addMedicationState.currentStep == 5) {
      return ViewMedicationSummary(addMedicationBloc: addMedBloc);
    }
    return Container();
  }
}
