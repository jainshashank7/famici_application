part of 'barrel.dart';

class MedicationSlider extends StatefulWidget {
  MedicationSlider({
    Key? key,
    List<dynamic>? meds,
  })  : _meds = meds ?? [],
        super(key: key);
  final List<dynamic> _meds;

  @override
  State<MedicationSlider> createState() => _MedicationSliderState();
}

class _MedicationSliderState extends State<MedicationSlider> {
  int selectedIndex = 0;

  List<dynamic> get items => widget._meds;

  double dragStartPosition = 0.0;

  void onDragEnd(DragEndDetails change) {
    var properties = TrackEvents().setProperties(
        fromDate: '',
        toDate: '',
        reading: '',
        readingDateTime: '',
        vital: '',
        appointmentDate: '',
        appointmentTime: '',
        appointmentCounselors: '',
        appointmentType: '',
        callDuration: '',
        readingType: '');

    TrackEvents().trackEvents('Mediacation Read (Slider)', properties);
    if (change.primaryVelocity! < 0) {
      setState(() {
        if (selectedIndex < items.length - 1) {
          selectedIndex++;
        } else {
          selectedIndex = 0;
        }
      });
    } else if (change.primaryVelocity! > 0) {
      setState(() {
        if (selectedIndex > 0) {
          selectedIndex--;
        } else {
          selectedIndex = items.length - 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget._meds.isEmpty) {
      return Container(
        width: 285 * FCStyle.fem,
        height: 326 * FCStyle.fem,
        alignment: Alignment.center,
        padding: EdgeInsets.all(15 * FCStyle.fem),
        decoration: BoxDecoration(
            color: ColorPallet.kTertiary,
            borderRadius: BorderRadius.circular(10 * FCStyle.fem)),
        child: Column(
          children: [
            Text(
              'Next Medicine',
              style: TextStyle(
                  color: ColorPallet.kTertiaryText,
                  fontFamily: 'roboto',
                  fontSize: 30 * FCStyle.ffem,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.only(top: 80 * FCStyle.fem),
              child: Center(
                child: Text(
                  "You don't have any medications",
                  style: FCStyle.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24 * FCStyle.ffem,
                      color: ColorPallet.kTertiaryText),
                  maxLines: 2,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      width: 285 * FCStyle.fem,
      height: 326 * FCStyle.fem,
      alignment: Alignment.center,
      padding: EdgeInsets.all(15 * FCStyle.fem),
      decoration: BoxDecoration(
          color: ColorPallet.kTertiary,
          borderRadius: BorderRadius.circular(10 * FCStyle.fem)),
      child: Column(
        children: [
          Text(
            'Next Medicine',
            style: TextStyle(
                color: ColorPallet.kTertiaryText,
                fontFamily: 'roboto',
                fontSize: 30 * FCStyle.ffem,
                fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onHorizontalDragEnd: onDragEnd,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeInOut,
                  child: MedicationSliderItem(
                    med: widget._meds[selectedIndex],
                  ),
                ),
                Container(
                  height: FCStyle.mediumFontSize,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int idx) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: FCStyle.smallFontSize,
                          width: FCStyle.smallFontSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 1, color: ColorPallet.kWhite),
                            color: idx == selectedIndex
                                ? ColorPallet.kTertiaryText
                                : Color.fromARGB(0, 55, 59, 187),
                          ),
                          alignment: Alignment.center,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MedicationSliderItem extends StatelessWidget {
  MedicationSliderItem({Key? key, required this.med}) : super(key: key);

  final Medication med;
  var random = Random();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: LayoutBuilder(builder: (context, cons) {
          return Container(
              color: Colors.transparent,
              height: 230 * FCStyle.fem,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   color: Color(0x1A000000),
                  //   width: 87 * FCStyle.fem,
                  //   height: 87 * FCStyle.fem,
                  //   child: SvgPicture.asset(
                  //     AssetIconPath.pillsIcon,
                  //     // width: 48 * FCStyle.fem,
                  //     // height: 65 * FCStyle.fem,
                  //   ),
                  // ),
                  Center(
                    child: Container(
                      height: 87 * FCStyle.fem,
                      width: 87 * FCStyle.fem,
                      margin: EdgeInsets.only(
                          top: 11 * FCStyle.fem, bottom: 11 * FCStyle.fem),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0x1A000000),
                      ),
                      padding: EdgeInsets.all(10 * FCStyle.fem),
                      child: CachedNetworkImage(
                        height: FCStyle.blockSizeVertical * 10,
                        fit: BoxFit.fitHeight,
                        imageUrl: med.imgUrl ?? "",
                        placeholder: (context, url) => SizedBox(
                          height: FCStyle.blockSizeVertical * 10,
                          child: Shimmer.fromColors(
                              baseColor: ColorPallet.kTertiaryText,
                              highlightColor: ColorPallet.kPrimaryGrey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                    size: 65 * FCStyle.fem,
                                  ),
                                ],
                              )),
                        ),
                        errorWidget: (context, url, error) => SizedBox(
                          height: 65 * FCStyle.fem,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center => Center Column contents horizontally,
                            children: <Widget>[
                              Icon(
                                Icons.broken_image,
                                size: 65 * FCStyle.fem,
                                color: ColorPallet.kTertiaryText,
                              ),
                            ],
                          ),
                        ),
                        fadeInCurve: Curves.easeIn,
                        fadeInDuration: const Duration(milliseconds: 100),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 42 * FCStyle.fem,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5 * FCStyle.fem),
                      child: Text(
                        med.medicationName ?? "Medicine Name",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30 * FCStyle.ffem,
                            fontWeight: FontWeight.w400,
                            color: ColorPallet.kTertiaryText),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5 * FCStyle.fem),
                    child: Text(
                      med.nextDosage?.detail ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25 * FCStyle.ffem,
                          fontWeight: FontWeight.w700,
                          color: ColorPallet.kTertiaryText),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 20 * FCStyle.fem),
                  //   child: Text(
                  //     "Take Before Breakfast",
                  //     style: TextStyle(
                  //         fontSize: 20 * FCStyle.ffem,
                  //         fontWeight: FontWeight.w400,
                  //         color: ColorPallet.kWhite),
                  //   ),
                  // ),
                ],
              ));
        }));
  }
}
