part of '../add_medication_screen.dart';

class ViewMedicationSummary extends StatefulWidget {
  const ViewMedicationSummary({Key? key, required this.addMedicationBloc})
      : super(key: key);

  final AddMedicationBloc addMedicationBloc;

  @override
  State<ViewMedicationSummary> createState() => _ViewMedicationSummaryState();
}

class _ViewMedicationSummaryState extends State<ViewMedicationSummary> {
  String medicationSummary = "";

  void generateSummary() {
    medicationSummary += MedicationStrings.medicationName.tr() +
        ": " +
        widget.addMedicationBloc.state.medicationName.value +
        "\n";
    medicationSummary += MedicationStrings.medicationType.tr() +
        ": " +
        widget.addMedicationBloc.state.selectedMedicationType.medicationType! +
        "\n";
    medicationSummary += MedicationStrings.frequency.tr() +
        ": " +
        MedicationStrings.takeNTimesADay.tr(
          args: [widget.addMedicationBloc.state.frequency.toString()],
        ) +
        "\n";
    if (widget.addMedicationBloc.state.selectedMedicationType.hasQuantity!) {
      medicationSummary += MedicationStrings.quantity.tr() +
          ": " +
          MedicationStrings.takeNPillsAtSpecificTimesOfADay.tr(
            args: [widget.addMedicationBloc.state.quantity.toString()],
          ) +
          "\n";
    }
    medicationSummary += MedicationStrings.timesOfMedication.tr() + ": ";
    for (int i = 0; i < widget.addMedicationBloc.state.dosageList.length; i++) {
      medicationSummary += DateFormat("hh:mm a").format(DateFormat("HH:mm")
              .parse(widget.addMedicationBloc.state.dosageList[i].time)) +
          (widget.addMedicationBloc.state.dosageList.length - 1 == i
              ? " "
              : ", ");
    }
    if (widget
        .addMedicationBloc.state.medicationAdditionalDetails.value.isNotEmpty) {
      medicationSummary += "\n" +
          MedicationStrings.additionalDetails.tr() +
          ": " +
          widget.addMedicationBloc.state.medicationAdditionalDetails.value +
          "\n";
    }
  }

  @override
  void initState() {
    generateSummary();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: FCStyle.blockSizeVertical * 3,
                ),
                Text(
                  MedicationStrings.medicationSummary.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FCStyle.largeFontSize,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: 32.0,
                  ),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: FCTextFormField(
                    readOnly: true,
                    key: FCElementID.medicationAdditionalInput,
                    initialValue: medicationSummary,
                    maxLines: 8,
                    textStyle: TextStyle(
                        fontSize: FCStyle.mediumFontSize + 4, height: 1.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FCRadioButton(
                        value: widget
                            .addMedicationBloc.state.enteredInformationCorrect,
                        hasError: (widget.addMedicationBloc.state.showErrors &&
                            !widget.addMedicationBloc.state
                                .enteredInformationCorrect),
                        groupValue: true,
                        onChanged: (value) {
                          widget.addMedicationBloc
                              .add(ToggleEnteredInformationCorrect());
                        },
                      ),
                      SizedBox(width: 16.0),
                      GestureDetector(
                        onTap: () {
                          widget.addMedicationBloc
                              .add(ToggleEnteredInformationCorrect());
                        },
                        child: Text(
                          MedicationStrings
                              .confirmThatAllInformationYouEnteredForThisMedicationIsAccurate
                              .tr(),
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: FCStyle.mediumFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        context.editButton(addMedicationBloc: widget.addMedicationBloc)
      ],
    );
  }
}
