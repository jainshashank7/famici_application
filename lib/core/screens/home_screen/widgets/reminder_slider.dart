part of 'barrel.dart';

class ReminderSlider extends StatefulWidget {
  ReminderSlider({
    Key? key,
    List<dynamic>? reminders,
  })  : _reminders = reminders ?? [],
        super(key: key);
  final List<dynamic> _reminders;

  @override
  State<ReminderSlider> createState() => _ReminderSliderState();
}

class _ReminderSliderState extends State<ReminderSlider> {
  int selectedIndex = 0;

  List<dynamic> get items => widget._reminders;

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
    return Container(
      width: 375 * FCStyle.fem,
      height: 156 * FCStyle.fem,
      alignment: Alignment.center,
      padding: EdgeInsets.all(15 * FCStyle.fem),
      decoration: BoxDecoration(
          color: const Color(0xCCAC2734),
          borderRadius: BorderRadius.circular(10 * FCStyle.fem)),
      child: GestureDetector(
        onHorizontalDragEnd: onDragEnd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeInOut,
              child: ReminderSliderItem(
                reminderText: widget._reminders[selectedIndex],
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
                            ? Color(0xFFFFFFFF)
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
    );
  }
}

class ReminderSliderItem extends StatelessWidget {
  const ReminderSliderItem({Key? key, required this.reminderText}) : super(key: key);

  final String reminderText;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: LayoutBuilder(builder: (context, cons) {
          return Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * FCStyle.fem,
                        0 * FCStyle.fem,
                        10.54 * FCStyle.fem,
                        13.37 * FCStyle.fem),
                    width: 60.46 * FCStyle.fem,
                    height: 66.63 * FCStyle.fem,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 12.46484375 * FCStyle.fem,
                          top: 14.9342651367 * FCStyle.fem,
                          child: Align(
                            child: SizedBox(
                              width: 42 * FCStyle.fem,
                              height: 51.69 * FCStyle.fem,
                              child: SvgPicture.asset(
                                AssetIconPath.notificationIcon,
                                width: 42 * FCStyle.fem,
                                height: 51.69 * FCStyle.fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 32 * FCStyle.fem,
                          top: 2 * FCStyle.fem,
                          child: Align(
                            child: SizedBox(
                              width: 28 * FCStyle.fem,
                              height: 28 * FCStyle.fem,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(14 * FCStyle.fem),
                                  color: Color(0xFF50B090),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 41 * FCStyle.fem,
                          top: 8 * FCStyle.fem,
                          child: Align(
                            child: SizedBox(
                              width: 11 * FCStyle.fem,
                              height: 18 * FCStyle.fem,
                              child: Text(
                                '3',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18 * FCStyle.ffem,
                                  fontWeight: FontWeight.w600,
                                  height: 1 * FCStyle.ffem / FCStyle.fem,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Reminders',
                        style: TextStyle(
                            color: ColorPallet.kWhite,
                            fontFamily: 'roboto',
                            fontSize: 35 * FCStyle.ffem,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(margin: EdgeInsets.only(bottom: 7 * FCStyle.fem, left: 10 * FCStyle.fem),
                        width: 175 * FCStyle.fem,
                        child: Text(
                          reminderText,
                          style: TextStyle(
                              color: ColorPallet.kWhite,
                              fontFamily: 'roboto',
                              fontSize: 22 * FCStyle.ffem,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),



                ],
              ));
        }));
  }
}
