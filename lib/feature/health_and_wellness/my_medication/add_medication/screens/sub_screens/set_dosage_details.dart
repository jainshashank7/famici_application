part of '../add_medication_screen.dart';

class SetDosageDetails extends StatefulWidget {
  const SetDosageDetails({Key? key, required this.addMedicationBloc})
      : super(key: key);

  final AddMedicationBloc addMedicationBloc;

  @override
  State<SetDosageDetails> createState() => _SetDosageDetailsState();
}

class _SetDosageDetailsState extends State<SetDosageDetails> {

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: FCStyle.blockSizeVertical*3,),
            Padding(
              padding: EdgeInsets.only(left: FCStyle.blockSizeHorizontal*18),
              child: Text(
                MedicationStrings.frequency.tr(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: FCStyle.largeFontSize,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: FCStyle.blockSizeHorizontal*18),
              child: Text(
                MedicationStrings.pleaseIndicateTimeAndAmountForEachDose.tr(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: FCStyle.mediumFontSize,
                ),
              ),
            ),
            SizedBox(
              height: FCStyle.blockSizeVertical*3,
            ),
            context.dosageDetailsColumnHeaders(),
            context.dosageDetails(context,widget.addMedicationBloc),

            Padding(
              padding: const EdgeInsets.only(left: 50,bottom: 100,top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  context.incrementButton(addMedicationBloc: widget.addMedicationBloc),
                  SizedBox(width: 20,),
                  Text(
                    MedicationStrings.addADose.tr(),
                    style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
