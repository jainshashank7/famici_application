part of '../add_medication_screen.dart';

class SetMedicationDuration extends StatefulWidget {
  const SetMedicationDuration({Key? key, required this.addMedicationBloc}) : super(key: key);

  final AddMedicationBloc addMedicationBloc;
  @override
  State<SetMedicationDuration> createState() => _SetMedicationDurationState();
}

class _SetMedicationDurationState extends State<SetMedicationDuration> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            SizedBox(width: 100,),
            Flexible(
                flex: 2,
                child: Container(
                  child: FCCalendarSetDosageDuration(addMedicationBloc:widget.addMedicationBloc,)
                )
            ),
            SizedBox(width: FCStyle.blockSizeHorizontal*5,),
            Flexible(
                flex: 1,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MedicationStrings.duration.tr(),
                      style: TextStyle(
                        color:widget.addMedicationBloc.state.showErrors ?
                            ColorPallet.kRed:
                        ColorPallet.kPrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: FCStyle.largeFontSize,
                      ),
                    ),
                    Text(
                      MedicationStrings.whatIsTheDurationOfThisMedication.tr(),
                      style: TextStyle(
                        color:widget.addMedicationBloc.state.showErrors?
                        ColorPallet.kRed:
                        ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                      ),
                    ),
                    SizedBox(height: 40,),
                    Text(
                      MedicationStrings.startDate.tr(),
                      style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                      ),
                    ),
                    ConcaveCard(
                      radius: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30,bottom: 20,top: 20),
                        child: Text(
                          ((widget.addMedicationBloc.state.startDate.year ==
                              DateTime.now().year &&
                              widget.addMedicationBloc.state.startDate.month ==
                                  DateTime.now().month &&
                              widget.addMedicationBloc.state.startDate.day ==
                                  DateTime.now().day) &&
                              (widget.addMedicationBloc.state.endDate.year ==
                                  DateTime.now().year &&
                                  widget.addMedicationBloc.state.endDate.month ==
                                      DateTime.now().month &&
                                  widget.addMedicationBloc.state.endDate.day ==
                                      DateTime.now().day))?
                                "--":
                          DateFormat.MMMd().format(widget.addMedicationBloc.state.startDate),
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: FCStyle.mediumFontSize,fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      MedicationStrings.endDate.tr(),
                      style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                      ),
                    ),
                    ConcaveCard(
                      radius: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30,bottom: 20,top: 20),
                        child: Text(
                          ((widget.addMedicationBloc.state.startDate.year ==
                              DateTime.now().year &&
                              widget.addMedicationBloc.state.startDate.month ==
                                  DateTime.now().month &&
                              widget.addMedicationBloc.state.startDate.day ==
                                  DateTime.now().day) &&
                              (widget.addMedicationBloc.state.endDate.year ==
                                  DateTime.now().year &&
                                  widget.addMedicationBloc.state.endDate.month ==
                                      DateTime.now().month &&
                                  widget.addMedicationBloc.state.endDate.day ==
                                      DateTime.now().day))
                            ||
                             ( widget.addMedicationBloc.state.startDate ==
                                  widget.addMedicationBloc.state.endDate)
                            ?
                          "--":
                          DateFormat.MMMd().format(widget.addMedicationBloc.state.endDate),
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: FCStyle.mediumFontSize,fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      MedicationStrings.totalDays.tr(),
                      style: TextStyle(
                        color: ColorPallet.kPrimaryTextColor,
                        fontSize: FCStyle.mediumFontSize,
                      ),
                    ),
                    ConcaveCard(
                      radius: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30,right: 30,bottom: 20,top: 20),
                        child: Text(
                            getDifferenceOfStartAndEnd(widget.addMedicationBloc.state.startDate,
                                widget.addMedicationBloc.state.endDate),
                          style: TextStyle(
                              color: ColorPallet.kPrimaryTextColor,
                              fontSize: FCStyle.mediumFontSize,fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(width: FCStyle.blockSizeHorizontal*5,),
          ],
        ),
      ),
    );
  }
  String getDifferenceOfStartAndEnd(DateTime startDate, DateTime endDate){

    if(startDate== DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
        && endDate== DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
      {
        return "--";
      }
    else if(
    ( widget.addMedicationBloc.state.startDate ==
    widget.addMedicationBloc.state.endDate))
      {
        return "--";
      }
    else{
      String differece= widget.addMedicationBloc.state.endDate.difference(
          widget.addMedicationBloc.state.startDate).inDays.toString();
      if(differece.contains("-"))
        {
          return "--";
        }
      else{
        return (int.parse(differece)+1).toString()+" "+MedicationStrings.days.tr();
      }

    }
  }
}
