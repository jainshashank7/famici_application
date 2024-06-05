import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/blocs/theme_bloc/theme_cubit.dart';
import '../../../core/screens/home_screen/widgets/barrel.dart';
import '../../../core/screens/home_screen/widgets/logout_button.dart';
import '../../../utils/config/color_pallet.dart';
import '../../../utils/constants/assets_paths.dart';
import '../chime_calling/chime_call.dart';
import 'my_profile.dart';

class FullVideoCallingScreen extends StatefulWidget {
  const FullVideoCallingScreen({Key? key}) : super(key: key);

  @override
  State<FullVideoCallingScreen> createState() => _FullVideoCallingScreenState();
}

class _FullVideoCallingScreenState extends State<FullVideoCallingScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return const Scaffold(
          body: VideoCallingScreen()
        );
      },
    );
  }
}
