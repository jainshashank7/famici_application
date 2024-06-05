part of '../add_medication_screen.dart';

class SetMedicationAdditionalDetails extends StatefulWidget {
  const SetMedicationAdditionalDetails({Key? key,required this.addMedicationBloc}) : super(key: key);

  final AddMedicationBloc addMedicationBloc;

  @override
  State<SetMedicationAdditionalDetails> createState() => _SetMedicationAdditionalDetailsState();
}

class _SetMedicationAdditionalDetailsState extends State<SetMedicationAdditionalDetails> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    _focusNode=FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 50,),
            Text(
              MedicationStrings.reminders.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: FCStyle.largeFontSize,
              ),
            ),
            Text(
              MedicationStrings.wouldYouLikeAReminderForThisMedication.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: FCStyle.mediumFontSize,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 48.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: (){
                      widget.addMedicationBloc
                          .add(OnDoseReminderToggle(ReminderType.allowed));
                    },
                    child: Text(
                      CommonStrings.yes.tr(),
                      style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  FCRadioButton(
                    value: ReminderType.allowed,
                    hasError: widget.addMedicationBloc.state.reminderAllowed.invalid,
                    groupValue:  widget.addMedicationBloc.state.reminderAllowed.value,
                    onChanged: (value) {
                      widget.addMedicationBloc
                          .add(OnDoseReminderToggle(value));
                    },
                  ),
                  SizedBox(width: 48.0),
                  FCRadioButton(
                    value: ReminderType.deny,
                    hasError: widget.addMedicationBloc.state.reminderAllowed.invalid,
                    groupValue:  widget.addMedicationBloc.state.reminderAllowed.value,
                    onChanged: (value) {
                      widget.addMedicationBloc
                          .add(OnDoseReminderToggle(value));
                    },
                  ),
                  SizedBox(width: 16.0),
                  GestureDetector(
                    onTap: (){
                      widget.addMedicationBloc
                          .add(OnDoseReminderToggle(ReminderType.deny));
                    },
                    child: Text(
                      CommonStrings.no.tr(),
                      style: TextStyle(
                          color: ColorPallet.kPrimaryTextColor,
                          fontSize: FCStyle.mediumFontSize,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(width: 48.0),
                ],
              ),
            ),
            Text(
              MedicationStrings.additionalDetailsAboutThisMedication.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPallet.kPrimaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: FCStyle.mediumFontSize,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 16.0,right: 50,
                bottom: 32.0,
              ),
              width: MediaQuery.of(context).size.width * 2 / 3,
              child: FCTextFormField(
                key: FCElementID.medicationAdditionalInput,
                initialValue: widget.addMedicationBloc.state.medicationAdditionalDetails.value,
                hasError: widget.addMedicationBloc.state.medicationAdditionalDetails.invalid,
                error: widget.addMedicationBloc.state.medicationAdditionalDetails.error?.message,
                focusNode: _focusNode,
                hintText: MedicationStrings.addYourMessageHere.tr(),
                maxLines: 4,
                textInputAction: TextInputAction.done,
                textInputFormatters: [LengthLimitingTextInputFormatter(100)],
                onChanged: (value) {
                  widget.addMedicationBloc.add(MedicationAdditionalDetailsChanged(value));
                },
                onComplete: () {
                  _focusNode.unfocus();
                },
              ),
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),
    );
  }
}
enum ReminderType { allowed, deny, unknown }
