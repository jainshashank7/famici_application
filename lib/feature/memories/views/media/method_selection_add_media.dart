import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/feature/camera/helpers/helper_methods.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/feature/memories/views/media/request_memories_popup.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../../shared/fc_back_button.dart';
import '../../../../shared/famici_scaffold.dart';
import '../../../connect_with_family/blocs/family_member/family_member_cubit.dart';
import '../../helpers/helper_methods.dart';

class MethodSelectionToAddMedia extends StatelessWidget {
  const MethodSelectionToAddMedia({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FamiciScaffold(
      bottomNavbar: FCBottomStatusBar(),
      title: Center(
        child: Text(
          'Photos',
          style: FCStyle.textStyle
              .copyWith(fontSize: 26, fontWeight: FontWeight.w700),
        ),
      ),
      topRight: LogoutButton(),
      leading: FCBackButton(onPressed: () {
        Navigator.pop(context);
      }),
      child: Container(
        margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 16),
        padding: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
            color: Color.fromARGB(229, 255, 255, 255),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(FCStyle.mediumFontSize),
              child: Text(
                'How do you want to add photos?',
                style: TextStyle(
                    color: ColorPallet.kPrimaryTextColor,
                    fontSize: 35 * FCStyle.fem,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        takePicture(context, (path) {
                          if (path != null) {
                            context.read<MemoriesBloc>().add(UploadImage(path));
                          }
                        }).then((value) => {Navigator.pop(context)});
                      },
                      child: Column(
                        children: [
                          // Image.asset(
                          //   DashboardIcons.camera,
                          //   width: 200,
                          // ),
                          SvgPicture.asset(
                            VitalIcons.camera,
                            width: 200,
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              "Use The Camera",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorPallet.kPrimaryTextColor,
                                  fontSize: 24 * FCStyle.fem,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: FCStyle.xLargeFontSize * 2),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        List<String> paths = await pickImagesFromGallery();
                        // for (var image in paths) {
                        context
                            .read<MemoriesBloc>()
                            .add(UploadMultiImage(paths));
                        // }
                        Navigator.of(context).pop();
                      },
                      child: Column(
                        children: [
                          // Image.asset(
                          //   DashboardIcons.imageFromDevice2,
                          //   width: 200,
                          // ),
                          SvgPicture.asset(
                            DashboardIcons.imageFromDevice,
                            width: 200,
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              "Select from Device",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorPallet.kPrimaryTextColor,
                                  fontSize: 24 * FCStyle.fem,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
