import 'package:auto_route/auto_route.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:famici/core/screens/barrel.dart';
import 'package:famici/core/screens/loading_screen/loading_screen.dart';
import 'package:famici/feature/calander/screens/calander_sceen.dart';
import 'package:famici/feature/calander/screens/create_appointment_screen.dart';
import 'package:famici/feature/calander/screens/ical_list_screen.dart';
import 'package:famici/feature/calander/views/new_appointment.dart';
import 'package:famici/feature/chat/chat_screen.dart';
import 'package:famici/feature/health_and_wellness/healthy_habits/screens/healthy_habits.dart';
import 'package:famici/feature/health_and_wellness/my_medication/add_medication/screens/add_medication_screen.dart';
import 'package:famici/feature/health_and_wellness/my_medication/screens/intake_history.dart';
import 'package:famici/feature/health_and_wellness/my_medication/screens/medication_details.dart';
import 'package:famici/feature/health_and_wellness/my_medication/screens/my_medicine_screen.dart';
import 'package:famici/feature/health_and_wellness/screens/health_and_wellness.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/screens/add_device_screen.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/screens/barrel.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/screens/view_vital_screen.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/screens/view_welness_screen.dart';

import 'package:famici/feature/memories/views/albums/album_screen.dart';
import 'package:famici/feature/memories/views/albums/create_album.dart';
import 'package:famici/feature/memories/views/memories_screen.dart';
import 'package:famici/feature/my_apps/screens/game_screen.dart';
import 'package:famici/feature/my_apps/screens/games_screen.dart';
import 'package:famici/feature/my_apps/screens/internet_screen.dart';
import 'package:famici/feature/my_apps/screens/my_apps.dart';
import 'package:famici/feature/notification/entities/notification.dart' as app;
import 'package:famici/feature/vitals/screens/history_data_screen.dart';
import 'package:famici/feature/vitals/screens/manual_entry_screen.dart';

import '../../feature/aws_chime/views/meeting.dart';
import '../../feature/calander/blocs/calendar/calendar_bloc.dart';
import '../../feature/calander/blocs/manage_appointment/manage_appointment_bloc.dart';
import '../../feature/calander/blocs/manage_reminders/manage_reminders_bloc.dart';
import '../../feature/calander/entities/appointments_entity.dart';
import '../../feature/calander/screens/appointment_notify_screen.dart';
import '../../feature/calander/views/view_appointment.dart';
import '../../feature/chat/multiple_chat_screen.dart';
import '../../feature/chat/widgets/chat_history.dart';
import '../../feature/education/entity/education_type.dart';
import '../../feature/education/screens/education_screen.dart';
import '../../feature/education/screens/expanded_education_screen.dart';
import '../../feature/health_and_wellness/my_medication/blocs/medication_bloc.dart';
import '../../feature/health_and_wellness/my_medication/entity/selected_medication_details.dart';
import '../../feature/health_and_wellness/my_medication/screens/add_edit_medication.dart';
import '../../feature/health_and_wellness/my_medication/screens/local_medication_notify_screen.dart';
import '../../feature/health_and_wellness/my_medication/screens/medication_notify_screen.dart';
import '../../feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import '../../feature/member_portal/chime_calling/chime_call.dart';
import '../../feature/member_portal/member_home.dart';
import '../../feature/member_portal/screens/full_video_calling_screen.dart';
import '../../feature/member_portal/screens/waiting_room_overview_screen.dart';
import '../../feature/member_portal/screens/waiting_room_screen.dart';
import '../../feature/mood_tracker/screens/mood_tracker.dart';
import '../../feature/mood_tracker/screens/mood_tracker_optional.dart';
import '../../feature/rss_feed/screens/rss_feed.dart';
import '../../utils/constants/enums.dart';
import '../screens/home_screen/fc_home_screen.dart';
import '../screens/home_screen/template_3.dart';
import '../screens/home_screen/widgets/calling_screen.dart';
import '../screens/home_screen/widgets/care_team_template2.dart';
import '../screens/lock_screen/lock_screen.dart';
import '../screens/multiple_user_screen/add_user_screen.dart';
import '../screens/multiple_user_screen/multiple_user_screen.dart';
import '../screens/multiple_user_screen/user_sceen.dart';
import '../screens/template/kiosk/rss_feed/feed.dart';

part 'router_delegate.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomeScreen, initial: true),
    AutoRoute(page: FCHomeScreen,),
    AutoRoute(page: CustomerSupportHomeScreen),
    AutoRoute(page: ChatScreen),
    AutoRoute(page: FamilyMemoriesScreen),
    AutoRoute(page: ViewAlbumScreen),
    AutoRoute(page: CreateAlbumScreen),
    AutoRoute(page: MyMedicineScreen),
    AutoRoute(page: MedicationDetailsScreen),
    AutoRoute(page: AddMedicationScreen),
    AutoRoute(page: HealthAndWellnessScreen),
    AutoRoute(page: HealthyHabitsScreen),
    AutoRoute(page: IntakeHistoryScreen),
    AutoRoute(page: VitalsAndWellnessScreen),
    AutoRoute(page: MyDevicesScreen),
    AutoRoute(page: AddDevicesScreen),
    AutoRoute(page: ViewVitalScreen),
    AutoRoute(page: ManualEntryScreen),
    AutoRoute(page: HistoryDataScreen),
    AutoRoute(page: ViewWellnessScreen),
    AutoRoute(page: MyAppScreen),
    AutoRoute(page: CalenderScreen),
    AutoRoute(page: CreateAppointmentScreen),
    AutoRoute(page: GamesSelectionScreen),
    AutoRoute(page: GameScreen),
    AutoRoute(page: InternetScreen),
    AutoRoute(page: CalendarAppointmentScreen),
    AutoRoute(page: NewAppointmentScreen),
    AutoRoute(page: MedicationNotifyScreen),
    AutoRoute(page: AppointmentNotifyScreen),
    AutoRoute(page: LockScreen),
    AutoRoute(page: MultipleUserScreen),
    AutoRoute(page: UserLoginScreen),
    AutoRoute(page: AddUserLoginScreen),
    AutoRoute(page: CareTeamScreen),
    AutoRoute(page: MultipleChatUserScreen),
    AutoRoute(page: MemberHomeScreen),
    AutoRoute(page: WaitingRoomScreen),
    AutoRoute(page: VideoCallingScreen),
    AutoRoute(page: FullVideoCallingScreen),
    AutoRoute(page: WaitingRoomOverViewScreen),
    AutoRoute(page: LocalMedicationNotifyScreen),
    AutoRoute(page: AddEditMedicationScreen),
    AutoRoute(page: IcalListScreen),
    AutoRoute(page: RssFeedScreen),
    AutoRoute(page: CallingScreen),
    AutoRoute(page: MoodTrackerScreen),
    AutoRoute(page: MoodTrackerOptionalScreen),
    AutoRoute(page: MeetingViewScreen),
    AutoRoute(page: LoadingScreen),
    AutoRoute(page: EducationScreen),
    AutoRoute(page: ExpandedEducationScreen),
  ],
)
class FCRouter extends _$FCRouter {}

final FCRouter fcRouter = FCRouter();
/*
 * Page name should contain 'Screen' at the end.
 * 'Screen' will replace with 'Route'.
 * Code generation need to run in order to effect the changes
 * TODO: You can run :-
           'flutter packages pub run build_runner build --delete-conflicting-outputs'  each time you edit this file
            OR
            'flutter packages pub run build_runner watch --delete-conflicting-outputs' to watch code changes and regenerate

*/