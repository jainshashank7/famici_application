import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/blocs/add_medication/add_medication_bloc.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/screens/select_medication_type_popup.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/confirm_medication_popup.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/view_medication_details_popup.dart';
import 'package:famici/shared/popup_scaffold.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/strings/medication_strings.dart';
import 'package:shimmer/shimmer.dart';

class SelectMedicationTypePopupHandler {
  Future<void> showSelectMedicationTypePopup(
      {required BuildContext context,
      required AddMedicationBloc addMedicationBloc}) {
    return showDialog(
      context: context,
      builder: (context) {
        return SelectMedicationTypePopup(
          addMedicationBloc: addMedicationBloc,
        );
      },
    );
  }
}
