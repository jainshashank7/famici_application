import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/connect_with_family/blocs/family_member/family_member_cubit.dart';
import 'package:famici/utils/barrel.dart';
import 'package:provider/src/provider.dart';
import 'package:famici/core/router/router.dart';
import 'package:famici/core/router/router_delegate.dart';
import 'package:easy_localization/easy_localization.dart';

class FCSquareButton extends StatelessWidget {
  const FCSquareButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: FCStyle.primaryButtonStyle,
      minDistance: 3,
      onPressed: () {
        context.read<FamilyMemberCubit>().resetUserViewing();
        // context.read<ScreenDistributorBloc>().add(ShowAddContactScreenEvent());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0,
              ),
              child: Icon(
                Icons.add_circle,
                size: FCStyle.largeFontSize,
                color: ColorPallet.kPrimaryTextColor,
              ),
            ),
            SizedBox(
              width: 160,
              child: Text(
                ConnectStrings.addFamilyMember.tr(),
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: FCStyle.mediumFontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
