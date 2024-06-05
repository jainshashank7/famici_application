import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/config/color_pallet.dart';
import '../entity/sub_module_link.dart';
import '../widgets/dashboard_grid_view_item.dart';
// import 'dashboard_grid_view_item.dart';

class GridItems extends StatelessWidget {
  const GridItems(
      {super.key,
      required this.gridViewItemList,
      required this.color,
      required this.textColor});

  final double itemWidth = 206.0;
  final double itemHeight = 135.0;

  // Define the responsive breakpoints for the number of columns
  final double tabletWidthBreakpoint = 600.0; // Width for tablets
  final double largeScreenWidthBreakpoint = 1440.0; // Width for 24-inch screen

  final List<SubModuleLink> gridViewItemList;
  final Color color;
  final Color textColor;

  // Calculate the number of columns based on the screen width
  int calculateGridColumns(double screenWidth) {
    if (screenWidth >= largeScreenWidthBreakpoint) {
      return 6; // 6 items in a row for large screens
    } else if (screenWidth >= tabletWidthBreakpoint) {
      return 4; // 4 items in a row for tablets
    } else {
      return 2; // 2 items in a row for mobile devices
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = calculateGridColumns(screenWidth);
    // return Flexible(
    //   child:

    print("hhhhhhhhh " + gridViewItemList.toString());
    return ListView(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          margin: MediaQuery.of(context).orientation == Orientation.landscape
              ? EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10)
              : screenWidth >= 1200
                  ? EdgeInsets.only(left: 0, right: 0, top: 50)
                  : EdgeInsets.only(
                      left: 0, right: 0, top: screenHeight * 0.01),
          height: screenHeight * 0.44,
          width: screenWidth,
          child: RawScrollbar(
            trackVisibility: true,
            radius: Radius.circular(10),
            thumbColor: ColorPallet.kPrimary,
            thickness: 5,
            thumbVisibility: true,
            child: GridView.builder(
              padding: EdgeInsets.only(left: 4, right: 10, top: 4),
              itemCount: gridViewItemList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 5
                        : screenWidth > 900
                            ? 3
                            : 3,
                crossAxisSpacing: screenWidth < 400 ? 10 : 20,
                mainAxisSpacing: screenWidth < 400 ? 10 : 20,
                // Number of columns based on screen width
                childAspectRatio: itemWidth / itemHeight, // Aspect ratio
              ),
              itemBuilder: (BuildContext context, int index) {
                // Replace this with your grid item widget
                return DashboardGridViewItem(
                  title: gridViewItemList[index].title,
                  link: gridViewItemList[index].url,
                  itemType: gridViewItemList[index].moduleType == 'pdf'
                      ? 'pdf'
                      : "link",
                  documentId: gridViewItemList[index].documentId,
                  color: color,
                  textColor: textColor,
                  isSensitive: gridViewItemList[index].isSensitive,
                  sensitiveScreenTimeOut: gridViewItemList[index].sensitiveScreenTimeOut ?? 30,
                  sensitiveAlertTimeOut: gridViewItemList[index].sensitiveAlertTimeOut ?? 15,
                );
              },
            ),
          ),
        ),
      ],
    );
    // );
  }
}
