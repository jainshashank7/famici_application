import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../core/router/router_delegate.dart';
import '../../../shared/fc_back_button.dart';
import '../../../shared/popup_scaffold.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/config/famici.theme.dart';
import '../../../utils/strings/common_strings.dart';

class ErrorMessagePopup extends StatelessWidget {
  const ErrorMessagePopup({
    Key? key,
    required this.message,
  }) : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return PopupScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorPallet.kDarkRed,
            ),
            padding: EdgeInsets.all(12.0),
            child: Icon(
              Icons.close,
              color: ColorPallet.kLightBackGround,
              size: 64,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 48.0),
            child: Text(
              message,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: FCStyle.textStyle.copyWith(
                fontSize: FCStyle.mediumFontSize,
              ),
            ),
          ),
          FCBackButton(
            onPressed: () {
              fcRouter.pop();
            },
            label: CommonStrings.back.tr(),
          )
        ],
      ),
    );
  }
}
