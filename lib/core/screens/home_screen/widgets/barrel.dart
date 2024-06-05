import 'dart:math';

import 'package:badges/badges.dart' as app;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:famici/core/blocs/app_bloc/app_bloc.dart';
import 'package:famici/core/blocs/theme_bloc/theme_cubit.dart';

import 'package:famici/core/router/router.dart';
import 'package:famici/core/router/router_delegate.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/calander/blocs/calendar/calendar_bloc.dart';
import 'package:famici/feature/calander/entities/appointments_entity.dart';
import 'package:famici/feature/health_and_wellness/my_medication/entity/medication.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/device_type_icon.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/widgets/vital_reading.dart';
import 'package:famici/feature/notification/blocs/notification_bloc/notification_bloc.dart';

import 'package:famici/shared/barrel.dart';
import 'package:famici/utils/config/color_pallet.dart';
import 'package:famici/utils/config/famici.theme.dart';
import 'package:famici/utils/constants/assets_paths.dart';
import 'package:famici/utils/helpers/widget_key.dart';
import 'package:famici/utils/strings/barrel.dart';
import 'package:famici/utils/strings/home_strings.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import '../../../../feature/calander/views/view_appointment.dart';
import '../../../../feature/care_team/blocs/care_team_bloc.dart';
import '../../../../feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import '../../../../utils/helpers/events_track.dart';
import '../../../blocs/connectivity_bloc/connectivity_bloc.dart';

export '../home_screen.dart';

part 'greeting_with_time.dart';
part 'notification_button.dart';
part 'vital_slider.dart';
part 'remember_to_list.dart';
part 'family_memories_button.dart';
part 'health_and_wellness_button.dart';
part 'connect_with_family_button.dart';
part 'my_apps_button.dart';
part 'messages_button.dart';
part 'appointments.dart';
part 'care_team.dart';
part 'medication_slider.dart';
part 'reminder_slider.dart';
