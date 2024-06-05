import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/feature/memories/blocs/memories/memories_bloc.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';

class EditIconButton extends StatelessWidget {
  const EditIconButton({
    Key? key,
    this.size,
    this.onTap,
    this.margin,
    this.color,
    this.boxed = false
  }) : super(key: key);

  final Function()? onTap;
  final double? size;
  final EdgeInsets? margin;
  final Color? color;
  final bool? boxed;
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      margin: margin,
      padding: margin,
      style: NeumorphicStyle(
        shape: boxed != false ? NeumorphicShape.convex : NeumorphicShape.flat,
        color: boxed != false
            ? ColorPallet.kPrimaryColor
            : Colors.transparent,
        disableDepth: true,
      ),
      onPressed: (){
        BlocProvider.of<MemoriesBloc>(context).add(EditPhotoMemory(context));
        // Navigator.of(context).pop();
      },
      child: NeumorphicIcon(
        Icons.edit,
        style: NeumorphicStyle(
          color: color ?? ColorPallet.kPrimaryTextColor,
          lightSource: LightSource.top,
          oppositeShadowLightSource: true,
          depth: 2,
          shadowLightColor: ColorPallet.kDark,
        ),
        size: size ?? FCStyle.xLargeFontSize,
      ),
    );
  }
}
