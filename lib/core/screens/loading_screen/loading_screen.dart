import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rive/rive.dart';
import 'package:famici/utils/config/famici.theme.dart';
import 'package:famici/utils/constants/assets_paths.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key, this.width, this.height}) : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width ?? FCStyle.xLargeFontSize * 3,
        height: height ?? FCStyle.xLargeFontSize * 3,
        child: const RiveAnimation.asset(
          AnimationPath.loader,
        ),
      ),
    );
  }
}
