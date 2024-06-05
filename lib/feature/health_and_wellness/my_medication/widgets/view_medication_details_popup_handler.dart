
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/confirm_medication_popup.dart';
import 'package:famici/feature/health_and_wellness/my_medication/widgets/view_medication_details_popup.dart';
import '../entity/medication.dart';

class MedicationDetailsPopupHandler {
  Future<void> showMedicationDetailsPopup(
      {required BuildContext context,
        required Medication medication
      }) {
    return showDialog(
      context: context,
      builder: (context) {
        if (medication.previousDosage?.hasPrompted!=null && medication.previousDosage?.hasPrompted==false)
      // if(1==1)
        {
          return ConfirmMedicationDetailsPopup(
            medication: medication,
          );

        } else {
          return MedicationDetailsPopup(
            medication: medication,
          );
        }
      },
    );
  }
}
