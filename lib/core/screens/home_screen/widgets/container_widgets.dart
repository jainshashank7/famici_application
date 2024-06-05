import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/router/router.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.textColor,
      required this.innerColor,
      required this.textWidth,required this.route});

  final String title;
  final String icon;
  final Color color;
  final Color textColor;
  final Color innerColor;
  final double textWidth;
  final dynamic route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        fcRouter.navigate(route);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1737,
        width: MediaQuery.of(context).size.width * 0.1993,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(5, 10),
                  blurRadius: 5,
                  spreadRadius: 5,
                  color: const Color(0xff000000).withOpacity(0.15),
                  blurStyle: BlurStyle.normal),
              // BoxShadow(
              //     offset: const Offset(0, 6),
              //     blurRadius: 4,
              //     spreadRadius: 0,
              //     color: const Color(0xffFFFFFF).withOpacity(0.7),
              //     blurStyle: BlurStyle.inner)
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02369,
          right: MediaQuery.of(context).size.width * 0.005),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.03119,
              // ),
              Container(
                width: textWidth,
                height: MediaQuery.of(context).size.width * 0.06907,
                alignment: Alignment.center,
                child: Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                      color: textColor,
                      fontSize: MediaQuery.of(context).size.height * 0.03119),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.0946,
                  width: MediaQuery.of(context).size.width * 0.0590,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: innerColor,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      icon,
                      height: MediaQuery.of(context).size.height * 0.04456,
                      width: MediaQuery.of(context).size.width * 0.0339,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
