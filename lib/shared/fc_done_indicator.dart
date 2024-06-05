import 'package:flutter/material.dart';
import 'package:famici/utils/config/color_pallet.dart';

class FCDoneIndicator extends StatelessWidget {
  const FCDoneIndicator({Key? key,this.width=65,this.height=65,this.iconSize=40, required this.isDone}) : super(key: key);

  final bool isDone;
  final double width;
  final double height;
  final double iconSize;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorPallet.kCardBackground,
        boxShadow: [
          BoxShadow(
            color: ColorPallet.kBlack,
            spreadRadius: -6,
            blurRadius: 12,
          ),
        ]
      ),
      child: isDone?Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorPallet.kDarkShadeGreen
        ),
        child: Icon(Icons.done,color: ColorPallet.kWhite,size: iconSize,),
      ):Container(),
    );
  }
}
