import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/feature/health_and_wellness/my_medication/entity/medication.dart';

import '../../../../feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import '../../../../utils/config/famici.theme.dart';
import '../../../router/router_delegate.dart';
import '../../loading_screen/loading_screen.dart';

class MedicationTemplate2 extends StatefulWidget {
  const MedicationTemplate2({super.key});

  @override
  State<MedicationTemplate2> createState() => _MedicationTemplate2State();
}

class _MedicationTemplate2State extends State<MedicationTemplate2> {
  int _currentIndex = 0;

  // late Timer _autoPlayTimer;

  final SwiperController _swiperController = SwiperController();

  @override
  void initState() {
    // _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
    //   // _currentIndex++;
    //   _swiperController.previous();
    //   // _swiperController.move(_currentIndex - 1);
    // });
    super.initState();
  }

  List<Medication> _medicationsUpToSixHours = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.26,
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      // color: Colors.blueGrey,
      child: BlocBuilder<MedicationBloc, MedicationState>(
        buildWhen: (prev, cur) =>
            cur.status == MedicationStatus.success && prev.status != cur.status,
        builder: (context, state) {
          DebugLogger.debug("get Medication Status: ${state.status}");
          if (state.status == MedicationStatus.loading ||
              state.status == MedicationStatus.initial ||
              state.status == MedicationStatus.intakeHistoryLoading) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/images/medicine_bg.svg',
                  ),
                ),
                Center(
                  child: LoadingScreen(
                    height: FCStyle.xLargeFontSize * 2,
                    width: FCStyle.xLargeFontSize * 2,
                  ),
                ),
              ],
            );
          }

          _medicationsUpToSixHours =
              _getMedicationUpToSixHours(state.medicationList);

          if (_medicationsUpToSixHours.isEmpty) {
            return GestureDetector(
              onTap: () {
                fcRouter.navigate(const MyMedicineRoute());
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/images/medicine_bg.svg',
                    ),
                  ),
                  Center(
                    child: Text(
                      "You don't have any medications",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromRGBO(81, 85, 195, 1.0),
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.width * 0.022,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (_medicationsUpToSixHours.length == 1) {
            return GestureDetector(
              onTap: () {
                fcRouter.navigate(const MyMedicineRoute());
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/images/medicine_bg.svg',
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.only(
                    // left: 16,
                    //     right: 16,
                    //     bottom: 40),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.08,
                        left: MediaQuery.of(context).size.width * 0.01),
                    width: MediaQuery.of(context).size.width * 0.24,
                    height: MediaQuery.of(context).size.height * 0.565,
                    decoration: BoxDecoration(
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color:
                      //     Colors.black26,
                      //     offset: Offset(
                      //     0.0, -0.2),
                      //     blurRadius: 0.0,
                      //     spreadRadius: 0.0
                      //   )
                      // ],
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Next Medicine",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width <= 500
                                ? MediaQuery.of(context).size.width * 0.06
                                : MediaQuery.of(context).size.width <= 850
                                    ? MediaQuery.of(context).size.width * 0.04
                                    : MediaQuery.of(context).size.width <= 1200
                                        ? MediaQuery.of(context).size.width *
                                            0.02
                                        : MediaQuery.of(context).size.width *
                                            0.015,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1376,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xffE6F1FB)),
                          child: Center(
                            child: CachedNetworkImage(
                              fit: BoxFit.fitHeight,
                              imageUrl:
                                  _medicationsUpToSixHours[0].imgUrl ?? "",
                              placeholder: (context, url) => Icon(
                                Icons.photo,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.broken_image,
                              ),
                              width: MediaQuery.of(context).size.width * 0.07,
                              height: MediaQuery.of(context).size.width * 0.09,
                            ),
                          ),
                        ),
                        Text(
                          _medicationsUpToSixHours[0].medicationName ??
                              "Medicine Name",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            color: const Color.fromRGBO(81, 85, 195, 1.0),
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width <= 500
                                ? MediaQuery.of(context).size.width * 0.1
                                : MediaQuery.of(context).size.width <= 850
                                    ? MediaQuery.of(context).size.width * 0.06
                                    : MediaQuery.of(context).size.width <= 1200
                                        ? MediaQuery.of(context).size.width *
                                            0.035
                                        : MediaQuery.of(context).size.width *
                                            0.025,
                          ),
                        ),
                        Text(
                          _medicationsUpToSixHours[0].nextDosage?.detail ?? "",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color.fromRGBO(81, 85, 195, 1.0),
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width <= 500
                                ? MediaQuery.of(context).size.width * 0.045
                                : MediaQuery.of(context).size.width <= 850
                                    ? MediaQuery.of(context).size.width * 0.03
                                    : MediaQuery.of(context).size.width <= 1200
                                        ? MediaQuery.of(context).size.width *
                                            0.017
                                        : MediaQuery.of(context).size.width *
                                            0.015,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return GestureDetector(
              onTap: () {
                fcRouter.navigate(const MyMedicineRoute());
              },
              child: Swiper(
                itemCount: _medicationsUpToSixHours.length,
                duration: 1000,
                itemBuilder: (swiperContext, index) {
                  return Container(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 40),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, -0.1),
                            blurRadius: 0.0,
                            spreadRadius: 0.0)
                      ],
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Next Medicine",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width <= 500
                                ? MediaQuery.of(context).size.width * 0.06
                                : MediaQuery.of(context).size.width <= 850
                                    ? MediaQuery.of(context).size.width * 0.04
                                    : MediaQuery.of(context).size.width <= 1200
                                        ? MediaQuery.of(context).size.width *
                                            0.02
                                        : MediaQuery.of(context).size.width *
                                            0.015,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1376,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xffE6F1FB)),
                          child: Center(
                            child: CachedNetworkImage(
                              fit: BoxFit.fitHeight,
                              imageUrl:
                                  _medicationsUpToSixHours[index].imgUrl ?? "",
                              placeholder: (context, url) => Icon(
                                Icons.photo,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.broken_image,
                              ),
                              width: MediaQuery.of(context).size.width * 0.07,
                              height: MediaQuery.of(context).size.width * 0.09,
                            ),
                          ),
                        ),
                        Text(
                          _medicationsUpToSixHours[index].medicationName ??
                              "Medicine Name",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            color: const Color.fromRGBO(81, 85, 195, 1.0),
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width <= 500
                                ? MediaQuery.of(context).size.width * 0.1
                                : MediaQuery.of(context).size.width <= 850
                                    ? MediaQuery.of(context).size.width * 0.06
                                    : MediaQuery.of(context).size.width <= 1200
                                        ? MediaQuery.of(context).size.width *
                                            0.035
                                        : MediaQuery.of(context).size.width *
                                            0.025,
                          ),
                        ),
                        Text(
                          _medicationsUpToSixHours[index].nextDosage?.detail ??
                              "",
                          maxLines: 2,
                          style: TextStyle(
                            color: const Color.fromRGBO(81, 85, 195, 1.0),
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width <= 500
                                ? MediaQuery.of(context).size.width * 0.045
                                : MediaQuery.of(context).size.width <= 850
                                    ? MediaQuery.of(context).size.width * 0.03
                                    : MediaQuery.of(context).size.width <= 1200
                                        ? MediaQuery.of(context).size.width *
                                            0.017
                                        : MediaQuery.of(context).size.width *
                                            0.015,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                // onTap: (index) {
                //   Navigator.of(context)
                //       .push(MaterialPageRoute<Object>(
                //     builder: (context) {
                //       return Scaffold(
                //         appBar: AppBar(
                //           title:
                //           const Text('New page'),
                //         ),
                //         body: Container(),
                //       );
                //     },
                //   ));
                // },
                customLayoutOption:
                    CustomLayoutOption(startIndex: -1, stateCount: 3)
                      ..addRotate([-25.0 / 180, 0.0, 25.0 / 180])
                      ..addTranslate([
                        const Offset(-350.0, 0.0),
                        const Offset(0.0, 0.0),
                        const Offset(350.0, 0.0)
                      ]),
                fade: 1.0,
                index: _currentIndex,
                onIndexChanged: (index) {
                  setState(() {
                    // _currentIndex = (_medicationsUpToSixHours.length - index) % _medicationsUpToSixHours.length;
                    _currentIndex = index;
                  });
                },
                curve: Curves.ease,
                scale: 0.8,
                itemWidth: MediaQuery.of(context).size.width * 0.24,
                controller: _swiperController,
                layout: SwiperLayout.STACK,
                outer: false,
                itemHeight: MediaQuery.of(context).size.height * 0.6,
                viewportFraction: 0.8,
                autoplayDelay: 5000,
                loop: true,
                autoplay: true,
                scrollDirection: Axis.horizontal,
                axisDirection: AxisDirection.right,
                indicatorLayout: PageIndicatorLayout.COLOR,
                autoplayDisableOnInteraction: true,
                pagination: const SwiperPagination(
                    margin: EdgeInsets.only(bottom: 30),
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        activeColor: Color.fromARGB(255, 81, 85, 195),
                        color: Color.fromARGB(255, 206, 209, 214),
                        size: 7.0,
                        activeSize: 7.0,
                        space: 1.0)),
              ));
        },
      ),
    );
  }

  List<Medication> _getMedicationUpToSixHours(
      List<Medication> medicationsList) {
    List<Medication> getNewMedicationsList = [];
    DateTime currentTime = DateTime.now();
    int currentTimeInSeconds =
        currentTime.hour * 60 * 60 + currentTime.minute * 60;
    for (Medication medication in medicationsList) {
      if (medication.nextDosage?.time != null) {
        int medicationTimeInSeconds =
            (int.parse(medication.nextDosage?.time.split(":")[0] ?? "0") *
                    60 *
                    60) +
                (int.parse(medication.nextDosage?.time.split(":")[1] ?? "0") *
                    60);
        if (medicationTimeInSeconds - currentTimeInSeconds < 21600 &&
            medicationTimeInSeconds - currentTimeInSeconds > 0) {
          getNewMedicationsList.add(medication);
        }
      }
    }
    return getNewMedicationsList;
  }
}
