import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/shared/fc_back_button.dart';
import 'package:famici/utils/barrel.dart';

import '../core/screens/home_screen/widgets/logout_button.dart';

class FamiciScaffold extends StatelessWidget {
  FamiciScaffold({
    Key? key,
    this.leading,
    this.title,
    this.child,
    this.trailing,
    this.bottomNavbar,
    this.resizeOnKeyboard = false,
    this.isLoading = false,
    this.toolbarPadding,
    this.toolbarElevation,
    this.topRight,
    double? toolbarHeight,
    this.backgroundImage,
    this.appbarBackground,
  })  : toolbarHeight = toolbarHeight ?? 128 * FCStyle.fem,
        super(key: key);
  final Widget? child;
  final Widget? trailing;
  final Widget? leading;
  final Widget? topRight;
  final Widget? title;
  final Widget? bottomNavbar;
  final bool isLoading;

  final double? toolbarHeight;
  final bool resizeOnKeyboard;
  final EdgeInsets? toolbarPadding;
  final double? toolbarElevation;
  final Color? appbarBackground;
  final String? backgroundImage;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.read<ThemeCubit>(),
      builder: (context, state) {
        return LayoutBuilder(builder: (context, cons) {
          return Stack(
            children: [
              Positioned.fill(child: Container(
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     fit: BoxFit.cover,
                //     image: CachedNetworkImage(),
                //   ),
                // ),
                  child: BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
                      builder: (context, state) {
                        if(backgroundImage != "" && backgroundImage != null) {
                          return CachedNetworkImage(
                            imageUrl: backgroundImage ?? "", // imageUrl:
                            //     'https://images.pexels.com/photos/262713/pexels-photo-262713.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            // imageUrl:
                            //     'httpsvscode-file://vscode-app/c:/Users/isha/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html://images.pexels.com/photos/370799/pexels-photo-370799.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            fit: BoxFit.cover,
                          );
                        }else if(state.themeData.background != '') {
                          return CachedNetworkImage(
                            imageUrl: state.themeData.background, // imageUrl:
                            //     'https://images.pexels.com/photos/262713/pexels-photo-262713.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            // imageUrl:
                            //     'httpsvscode-file://vscode-app/c:/Users/isha/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html://images.pexels.com/photos/370799/pexels-photo-370799.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/images/background_gradient.jpg"),
                                ),
                              ));
                        }
                      }))),
              Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Container(
                    margin: EdgeInsets.fromLTRB(0 * FCStyle.fem,
                        16 * FCStyle.fem, 0 * FCStyle.fem, 16 * FCStyle.fem),
                    padding: EdgeInsets.fromLTRB(
                        40 * FCStyle.fem,
                        18 * FCStyle.fem,
                        33.26 * FCStyle.fem,
                        18 * FCStyle.fem),
                    width: double.infinity,
                    height: 96 * FCStyle.fem,
                    decoration: BoxDecoration(
                      color: const Color(0xe5ffffff),
                      borderRadius: BorderRadius.circular(10 * FCStyle.fem),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: LeadingWidget(child: leading),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TitleWidget(child: title),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: TrailingWidget(trailing: trailing),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TopRightWidget(child: topRight),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  elevation: toolbarElevation ?? 0,
                  toolbarHeight: toolbarHeight,
                  backgroundColor: appbarBackground ?? Colors.transparent,
                ),
                backgroundColor: Colors.transparent,
                body: child,
                bottomNavigationBar: bottomNavbar,
                resizeToAvoidBottomInset: resizeOnKeyboard,
              ),
              isLoading
                  ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: ColorPallet.kDarkBackGround.withOpacity(0.6),
                child: Center(
                  child: LoadingScreen(
                    height: 120.r,
                  ),
                ),
              )
                  : SizedBox.shrink(),
            ],
          );
        });
      },
    );
  }
}

class LeadingWidget extends StatelessWidget {
  const LeadingWidget({
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Container(child: child);
    } else if (Navigator.canPop(context)) {
      return FCBackButton();
    }

    return SizedBox.shrink();
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Container(child: child);
    }
    return SizedBox.shrink();
  }
}

class TopRightWidget extends StatelessWidget {
  const TopRightWidget({
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Container(child: child);
    }
    return SizedBox.shrink();
  }
}

class TrailingWidget extends StatelessWidget {
  const TrailingWidget({
    Key? key,
    this.trailing,
  }) : super(key: key);
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (trailing != null) {
      return Container(child: trailing);
    }
    return SizedBox.shrink();
  }
}
