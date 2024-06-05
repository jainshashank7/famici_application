part of 'barrel.dart';

class VitalsSlider extends StatefulWidget {
  VitalsSlider({
    Key? key,
    List<dynamic>? vitals,
  })  : _vitals = vitals ?? [],
        super(key: key);
  final List<dynamic> _vitals;

  @override
  State<VitalsSlider> createState() => _VitalsSliderState();
}

class _VitalsSliderState extends State<VitalsSlider> {
  int selectedIndex = 0;

  List<dynamic> get items =>
      widget._vitals.length > 5 ? widget._vitals.sublist(0, 5) : widget._vitals;

  double dragStartPosition = 0.0;

  void onDragEnd(DragEndDetails change) {
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
    // print(items);
    if (widget._vitals.isEmpty) {
      return Center(
        child: ConcaveCard(
          child: SizedBox(
            height: 326 * FCStyle.fem,
            width: 278 * FCStyle.fem,
            child: Center(
              child: LoadingScreen(
                width: FCStyle.mediumFontSize * 3,
                height: FCStyle.mediumFontSize * 3,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: 285 * FCStyle.fem,
      height: 326 * FCStyle.fem,
      alignment: Alignment.center,
      padding: EdgeInsets.all(15 * FCStyle.fem),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10 * FCStyle.fem)),
      child: Column(
        children: [
          Text(
            'Vitals',
            style: TextStyle(
                color: Colors.black,
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
                  child: VitalSliderItem(
                    vital: widget._vitals[selectedIndex],
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
                            border: Border.all(
                                width: 1, color: ColorPallet.kPrimary),
                            color: idx == selectedIndex
                                ? ColorPallet.kPrimary
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

class VitalSliderItem extends StatelessWidget {
  const VitalSliderItem({Key? key, required this.vital}) : super(key: key);

  final Vital vital;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          left: 5,
        ),
        child: LayoutBuilder(builder: (context, cons) {
          return Container(
            color: Colors.transparent,
            child: vital.name != null
                ? Column(
                    children: [
                      SizedBox(
                        height: 15 * FCStyle.fem,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DeviceTypeIcon(
                            color: ColorPallet.kPrimary,
                            type: vital.vitalType,
                            size: 20,
                          ),
                          SizedBox(width: 10 * FCStyle.fem),
                          Text(
                            vital.name!,
                            style: TextStyle(
                                color: ColorPallet.kPrimary,
                                fontFamily: 'roboto',
                                fontSize: 26 * FCStyle.ffem,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      Container(
                        height: 150 * FCStyle.fem,
                        width: 240 * FCStyle.fem,
                        margin: EdgeInsets.only(
                            top: 11 * FCStyle.fem, bottom: 11 * FCStyle.fem),
                        padding: EdgeInsets.all(10 * FCStyle.fem),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorPallet.kPrimary.withOpacity(0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(children: [
                              FittedBox(
                                child: VitalReadingWithoutUnit(
                                  vital: vital,
                                  forceSingleLine: true,
                                  textStyle: TextStyle(
                                      color: ColorPallet.kPrimary,
                                      fontFamily: 'roboto',
                                      fontSize: 30 * FCStyle.ffem,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                vital.measureUnit!,
                                style: TextStyle(
                                    color: ColorPallet.kPrimary,
                                    fontFamily: 'roboto',
                                    fontSize: 30 * FCStyle.ffem,
                                    fontWeight: FontWeight.w700),
                              )
                            ]),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Last Reading',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 22 * FCStyle.ffem,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    DateFormat('MMMM d, h:mm a')
                                        .format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                vital.reading.readAt * 1000))
                                        .replaceAll('am', 'AM')
                                        .replaceAll('pm', 'PM')
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'roboto',
                                        fontSize: 20 * FCStyle.ffem,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            // const Divider(
                            //   height: 10,
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 8.0),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         'Next Reading Time',
                            //         style: TextStyle(
                            //             color: Colors.black,
                            //             fontFamily: 'roboto',
                            //             fontSize: 18 * FCStyle.ffem,
                            //             fontWeight: FontWeight.w600),
                            //       ),
                            //       const SizedBox(
                            //         height: 2,
                            //       ),
                            //       Text(
                            //         style: TextStyle(
                            //             color: Colors.black,
                            //             fontFamily: 'roboto',
                            //             fontSize: 15 * FCStyle.ffem,
                            //             fontWeight: FontWeight.w400),
                            //         DateFormat('MMMM d, h:mm a')
                            //             .format(
                            //           DateTime.fromMicrosecondsSinceEpoch(
                            //               vital.reading.readAt * 1000)
                            //               .add(const Duration(
                            //               days: 1,
                            //               hours: 8,
                            //               minutes: 20)),
                            //         )
                            //             .replaceAll('am', 'AM')
                            //             .replaceAll('pm', 'PM')
                            //             .toString(),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const LoadingScreen(),
          );
        }));
  }
}
