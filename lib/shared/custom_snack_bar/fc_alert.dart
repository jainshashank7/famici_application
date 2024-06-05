import 'package:flutter/cupertino.dart';
import 'package:famici/shared/custom_snack_bar/top_snack_bar.dart';
import 'package:famici/utils/barrel.dart';

import '../../core/router/router_delegate.dart';
import 'custom_snack_bar.dart';

class FCAlert {
  static Future<OverlayEntry?> showError(
    String error, {
    Duration? duration,
  }) async {
    if (fcRouter.navigatorKey.currentContext == null) {
      return null;
    }
    return await showTopSnackBar(
      fcRouter.navigatorKey.currentContext!,
      CustomSnackBar.error(
        message: error,
        textStyle: FCStyle.textStyle.copyWith(color: ColorPallet.kWhite),
      ),
      displayDuration: duration ?? Duration(milliseconds: 3000),
    );
  }

  static Future<OverlayEntry?> showInfo(
    String info, {
    Duration? duration,
  }) async {
    if (fcRouter.navigatorKey.currentContext == null) {
      return null;
    }
    return await showTopSnackBar(
      fcRouter.navigatorKey.currentContext!,
      CustomSnackBar.info(
        message: info,
        textStyle: FCStyle.textStyle.copyWith(color: ColorPallet.kWhite),
      ),
      displayDuration: duration ?? Duration(milliseconds: 3000),
    );
  }

  static Future<OverlayEntry?> showSuccess(
    String success, {
    Duration? duration,
  }) async {
    if (fcRouter.navigatorKey.currentContext == null) {
      return null;
    }
    return await showTopSnackBar(
      fcRouter.navigatorKey.currentContext!,
      CustomSnackBar.success(
        message: success,
        textStyle: FCStyle.textStyle.copyWith(color: ColorPallet.kWhite),
      ),
      displayDuration: duration ?? Duration(milliseconds: 3000),
    );
  }
}

// class FCConfirmDialog extends StatelessWidget {
//   const FCConfirmDialog({Key? key, this.title, this.subTitle, this.positiveBtnLabel, this.negativeBtnLabel, this.positiveAction, this.negativeAction}) : super(key: key);
//   final String? title;
//   final String? subTitle;
//   final  String? positiveBtnLabel;
//   final String? negativeBtnLabel;
//   final Function()? positiveAction;
//   final Function()? negativeAction;
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoAlertDialog(
//       title: FCText(text: title??CommonStrings.areYouSureContinue.tr(),fontSize: FCStyle.mediumFontSize+2,fontWeight: FontWeight.w500),
//       content: FCText(text: subTitle??CommonStrings.thisActionCannotBeUndone.tr(),fontSize: FCStyle.smallFontSize+2),
//       actions: <Widget>[
//         CupertinoDialogAction(
//           isDefaultAction: true,
//           child: FCText(
//               text: positiveBtnLabel??CommonStrings.ok.tr(),
//               fontSize: FCStyle.mediumFontSize,
//               fontWeight: FontWeight.bold,
//               textColor: ColorPallet.kBlue),
//           onPressed: positiveAction??(){Navigator.pop(context, true);},
//         ),
//         CupertinoDialogAction(
//           isDefaultAction: true,
//           child: FCText(text: negativeBtnLabel??CommonStrings.cancel.tr(),
//               fontSize: FCStyle.mediumFontSize,
//               fontWeight: FontWeight.bold,textColor: ColorPallet.kRed),
//           onPressed:negativeAction?? (){
//             Navigator.pop(context, false);
//           },
//         ),
//       ],
//     );
//   }
// }
