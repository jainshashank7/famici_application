import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:famici/utils/barrel.dart';

class EmptyMedicationDetails extends StatefulWidget {
  const EmptyMedicationDetails({Key? key}) : super(key: key);

  @override
  _EmptyMedicationDetailsState createState() => _EmptyMedicationDetailsState();
}

class _EmptyMedicationDetailsState extends State<EmptyMedicationDetails> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.fromLTRB(16 * FCStyle.fem, 0 * FCStyle.fem,
            16 * FCStyle.fem, 16.87 * FCStyle.fem),
        padding: EdgeInsets.fromLTRB(225 * FCStyle.fem, 121 * FCStyle.fem,
            316.5 * FCStyle.fem, 117.51 * FCStyle.fem),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xe5ffffff),
          borderRadius: BorderRadius.circular(10 * FCStyle.fem),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(14.5 * FCStyle.fem, 0 * FCStyle.fem,
                  0 * FCStyle.fem, 15 * FCStyle.fem),
              child: Text(
                'Medicine list empty, No medications added yet.\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 40 * FCStyle.ffem,
                  fontWeight: FontWeight.w500,
                  height: 1 * FCStyle.ffem / FCStyle.fem,
                  color: ColorPallet.kPrimary,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 0 * FCStyle.fem,
                  850.5 * FCStyle.fem, 18 * FCStyle.fem),
              width: 8 * FCStyle.fem,
              height: 4 * FCStyle.fem,
              child: SvgPicture.asset(
                AssetIconPath.emptyMedicationIcon,
                width: 8 * FCStyle.fem,
                height: 4 * FCStyle.fem,
              ),
            ),
            Opacity(
              opacity: 0.7,
              child: Container(
                margin: EdgeInsets.fromLTRB(0 * FCStyle.fem, 0 * FCStyle.fem,
                    44.5 * FCStyle.fem, 0 * FCStyle.fem),
                width: 370 * FCStyle.fem,
                height: 312.49 * FCStyle.fem,
                child: SvgPicture.asset(
                  AssetIconPath.emptyMedicationIcon,
                  width: 370 * FCStyle.fem,
                  height: 312.49 * FCStyle.fem,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
