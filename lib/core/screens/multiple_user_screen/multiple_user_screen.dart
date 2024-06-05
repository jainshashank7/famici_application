import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';
import 'package:famici/core/screens/multiple_user_screen/user_icon.dart';
import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'package:famici/utils/helpers/widget_key.dart';

import '../../blocs/app_bloc/app_bloc.dart';
import '../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../offline/local_database/users_db.dart';
import '../home_screen/widgets/bottom_status_bar.dart';

class MultipleUserScreen extends StatefulWidget {
  const MultipleUserScreen({Key? key}) : super(key: key);

  @override
  State<MultipleUserScreen> createState() => _MultipleUserScreenState();
}

class _MultipleUserScreenState extends State<MultipleUserScreen> {
  // final FocusScopeNode _node = FocusScopeNode();

  var items = [
    "Add new user",
  ];
  var emails = [];

  userDetails() async {
    final DatabaseHelperForUsers dbFactory = DatabaseHelperForUsers();
    List<Map<String, dynamic>> userData = await dbFactory.readDataFromTable();
    items = [];
    emails = [];
    items.add("Add new user");
    for (Map<String, dynamic> row in userData) {
      items.add(row["name"]);
      emails.add(row["username"]);
    }
    setState(() {
      items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        userDetails();
        Widget AddUserIconWithName(int index, var items) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AddUserIcon(),
                SizedBox(height: FCStyle.mediumFontSize),
                Text(
                  items[index],
                  style: TextStyle(
                    fontSize: FCStyle.mediumFontSize,
                    color: themeState.isDark
                        ? ColorPallet.kPrimaryGrey
                        : ColorPallet.kPrimaryColor,
                  ),
                ),
              ],
            ),
          ));
        }

        Widget UserIconWithName(int index, var items, List emails) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  UserIcon(email: emails[index - 1]),
                  SizedBox(height: FCStyle.mediumFontSize),
                  Text(
                    items[index],
                    style: TextStyle(
                      fontSize: FCStyle.mediumFontSize,
                      color: themeState.isDark
                          ? ColorPallet.kPrimaryGrey
                          : ColorPallet.kPrimaryColor,
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return BlocBuilder<ThemeBuilderBloc, ThemeBuilderState>(
  builder: (context, stateM) {
    return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                  child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [ColorPallet.kBackground, ColorPallet.kBackground],
                  ),
                ),
              )),
              MediaQuery.of(context).viewInsets.bottom > 0.0
                  ? SizedBox.shrink()
                  : Align(
                      alignment: Alignment(0, -0.4),
                      child: Container(
                        height: FCStyle.screenHeight / 6,
                        child: Image(
                          image: AssetImage(themeState.isDark
                              ? DashboardIcons.mobexNewLogoVertical
                              : DashboardIcons.mobexNewLogoVertical),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
              Stack(
                children: [
                  // const Positioned(left: 40.0, top: 40.0, child: FCBackButton()),
                  Align(
                    alignment: Alignment.topRight,
                    child: BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(right: 100.0, top: 80.0),
                          child: Text(
                            state.time,
                            key: FCElementID.lockScreenTimeKey,
                            style: FCStyle.textStyle.copyWith(
                              fontSize: FCStyle.largeFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (MediaQuery.of(context).viewInsets.bottom > 0.0)
                    Positioned.fill(
                        child: Container(
                      color: ColorPallet.kBlack.withOpacity(0.8),
                    )),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        100,
                        (FCStyle.screenHeight / 2) - (FCStyle.screenHeight / 5),
                        100,
                        0),
                    child: Padding(
                      padding: EdgeInsets.only(top: FCStyle.screenHeight / 6),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return AddUserIconWithName(index, items);
                          } else {
                            return UserIconWithName(index, items, emails);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: stateM.templateId != 2 ? const FCBottomStatusBar() : const BottomStatusBar(),
        );
  },
);
      },
    );
  }
}
