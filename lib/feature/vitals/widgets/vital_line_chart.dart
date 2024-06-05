import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/chat/entities/message.dart';
import 'package:famici/utils/barrel.dart';

import '../blocs/vital_history_bloc/vital_history_bloc.dart';

class VitalsLineChart extends StatelessWidget {
  const VitalsLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VitalHistoryBloc, VitalHistoryState>(
      buildWhen: (curr, prv) => curr.chart != prv.chart,
      builder: (context, state) {
        return LineChart(
          state.chart,
          swapAnimationDuration: const Duration(milliseconds: 250),
        );
      },
    );
  }
}
