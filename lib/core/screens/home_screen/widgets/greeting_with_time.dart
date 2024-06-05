part of 'barrel.dart';

class GreetingWithTime extends StatelessWidget {
  const GreetingWithTime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return BlocBuilder<AppBloc, AppState>(
        buildWhen: (prv, next) => prv.time != next.time,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0*FCStyle.fem, 10*FCStyle.fem, 14*FCStyle.fem, 5*FCStyle.fem),
                child: Text(
                  state.time,
                  style: TextStyle(
                    fontSize: 28*FCStyle.ffem,
                    fontWeight: FontWeight.w800,
                    height: 1*FCStyle.ffem/FCStyle.fem,
                    color: ColorPallet.kPrimaryTextColor,
                  ),
                ),
              ),
              Text(
                state.date,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorPallet.kPrimaryTextColor,
                  fontSize: 20*FCStyle.ffem,
                  height:1*FCStyle.ffem/FCStyle.fem,
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
