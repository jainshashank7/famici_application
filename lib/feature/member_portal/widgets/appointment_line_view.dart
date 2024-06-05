import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/utils/barrel.dart';

import '../../calander/entities/appointments_entity.dart';

class AppointmentLineView extends StatelessWidget {
  final Appointment appointment;

  const AppointmentLineView({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(
                DateFormat("MM/dd/yyyy").format(appointment.appointmentDate),
                style: TextStyle(
                  color: ColorPallet.kPrimaryColor,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: Text(
                  DateFormat.jm().format(appointment.startTime),
                  style: TextStyle(
                    color: ColorPallet.kPrimaryColor,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: Text(
                  getCounselors(appointment),
                  style: TextStyle(
                    color: ColorPallet.kPrimaryColor,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    AssetIconPath.telehealthIcon,
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                      appointment.appointmentType.name,
                      style: TextStyle(
                        color: ColorPallet.kPrimaryColor,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
              // Text(
              //   "Yet to create invoice",
              //   style: TextStyle(
              //     color: ColorPallet.kPrimaryColor,
              //     fontSize: 20,
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          color: ColorPallet.kPrimaryGrey,
          width: MediaQuery.of(context).size.width * 0.7,
          height: 1,
        )
      ],
    );
  }

  String getCounselors(Appointment appointment) {
    var counselors = appointment.counselors;
    List<dynamic> data = [];
    for (var counselor in counselors) {
      data.add(counselor.name);
    }
    return data.join(", ");
  }
}
