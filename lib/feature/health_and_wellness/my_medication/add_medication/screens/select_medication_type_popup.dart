import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/entity/medication_type.dart';
import 'package:famici/feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/medication_buttons.dart';
import 'package:famici/shared/fc_primary_button.dart';
import 'package:famici/shared/popup_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/medication_strings.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../shared/fc_material_button.dart';
import '../../widgets/medication_types_loading.dart';
import '../blocs/add_medication/add_medication_bloc.dart';

class SelectMedicationTypePopup extends StatefulWidget {
  const SelectMedicationTypePopup({Key? key, required this.addMedicationBloc})
      : super(key: key);

  final AddMedicationBloc addMedicationBloc;

  @override
  State<SelectMedicationTypePopup> createState() =>
      _SelectMedicationTypePopupState();
}

class _SelectMedicationTypePopupState extends State<SelectMedicationTypePopup> {
  late MedicationType _selectedType;
  @override
  void initState() {
    widget.addMedicationBloc.add(FetchMedicationTypes());
    _selectedType = widget.addMedicationBloc.state.selectedMedicationType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => widget.addMedicationBloc,
        child: BlocConsumer(
            bloc: widget.addMedicationBloc,
            listener: (context, AddMedicationState state) {
              if (state.status == MedicationFormStatus.success) {
                Navigator.pop(context);
              }
            },
            builder:
                (BuildContext context, AddMedicationState addMedicationState) {
              return PopupScaffold(
                width: 1128 * FCStyle.fem,
                backgroundColor: Color.fromARGB(147, 0, 0, 0),
                bodyColor: Colors.white,
                child: Column(
                  children: [
                    Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              width: double.infinity,
                              height: 95 * FCStyle.fem,
                              decoration: BoxDecoration(
                                color: ColorPallet.kPrimary.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(10 * FCStyle.fem),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * FCStyle.fem,
                                        0 * FCStyle.fem,
                                        0 * FCStyle.fem,
                                        0 * FCStyle.fem),
                                    child: Text(
                                      'Select a Medication Type',
                                      style: TextStyle(
                                        fontSize: 45 * FCStyle.ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1 * FCStyle.ffem / FCStyle.fem,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * FCStyle.fem,
                                        0 * FCStyle.fem,
                                        0 * FCStyle.fem,
                                        1 * FCStyle.fem),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFFAC2734),
                                        radius: 35 * FCStyle.fem,
                                        child: SvgPicture.asset(
                                          AssetIconPath.closeIcon,
                                          width: 35 * FCStyle.fem,
                                          height: 35 * FCStyle.fem,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: AnimationLimiter(
                        child: addMedicationState.medicationTypes.isEmpty
                            ? MedicationTypesLoading()
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: (FCStyle.screenHeight -
                                          FCStyle.xLargeFontSize * 1) /
                                      FCStyle.screenHeight,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    addMedicationState.medicationTypes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    delay: Duration(milliseconds: 100),
                                    duration: const Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      horizontalOffset: 100.0,
                                      child: FadeInAnimation(
                                        child: MedicationButtons()
                                            .selectMedicationTypeButton(
                                                medicationType:
                                                    addMedicationState
                                                        .medicationTypes[index],
                                                context: context,
                                                addMedicationBloc:
                                                    widget.addMedicationBloc,
                                                isSelected: _selectedType
                                                        .medicationTypeId ==
                                                    addMedicationState
                                                        .medicationTypes[index]
                                                        .medicationTypeId,
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedType =
                                                        addMedicationState
                                                                .medicationTypes[
                                                            index];
                                                  });
                                                }),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FCMaterialButton(
                      defaultSize: false,
                      elevation:
                          _selectedType.medicationTypeId?.isNotEmpty ?? false
                              ? 5
                              : 0,
                      onPressed: _selectedType.medicationTypeId?.isNotEmpty ??
                              false
                          ? () {
                              widget.addMedicationBloc
                                  .add(MedicationTypeSelected(_selectedType));
                              Navigator.pop(context, true);
                            }
                          : () {},
                      color: _selectedType.medicationTypeId?.isNotEmpty ?? false
                          ? ColorPallet.kPrimary
                          : ColorPallet.kLightBackGround,
                      child: Text('Save Medication Type ',
                          style: TextStyle(
                            color: _selectedType.medicationTypeId?.isNotEmpty ??
                                    false
                                ? ColorPallet.kPrimaryText
                                : ColorPallet.kGrey.withOpacity(0.6),
                            fontSize: FCStyle.mediumFontSize,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(
                      height: FCStyle.blockSizeVertical * 5,
                    )
                  ],
                ),
              );
            }));
  }
}
