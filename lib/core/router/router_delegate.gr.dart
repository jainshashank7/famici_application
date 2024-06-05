// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router_delegate.dart';

class _$FCRouter extends RootStackRouter {
  _$FCRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    FCHomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const FCHomeScreen(),
      );
    },
    CustomerSupportHomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CustomerSupportHomeScreen(),
      );
    },
    ChatRoute.name: (routeData) {
      final args =
          routeData.argsAs<ChatRouteArgs>(orElse: () => const ChatRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ChatScreen(
          key: args.key,
          shouldOpenSession: args.shouldOpenSession,
        ),
      );
    },
    FamilyMemoriesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const FamilyMemoriesScreen(),
      );
    },
    ViewAlbumRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ViewAlbumScreen(),
      );
    },
    CreateAlbumRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CreateAlbumScreen(),
      );
    },
    MyMedicineRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MyMedicineScreen(),
      );
    },
    MedicationDetailsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MedicationDetailsScreen(),
      );
    },
    AddMedicationRoute.name: (routeData) {
      final args = routeData.argsAs<AddMedicationRouteArgs>(
          orElse: () => const AddMedicationRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: AddMedicationScreen(
          key: args.key,
          fromEditing: args.fromEditing,
          medicationStateForEditing: args.medicationStateForEditing,
        ),
      );
    },
    HealthAndWellnessRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HealthAndWellnessScreen(),
      );
    },
    HealthyHabitsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HealthyHabitsScreen(),
      );
    },
    IntakeHistoryRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const IntakeHistoryScreen(),
      );
    },
    VitalsAndWellnessRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const VitalsAndWellnessScreen(),
      );
    },
    MyDevicesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MyDevicesScreen(),
      );
    },
    AddDevicesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const AddDevicesScreen(),
      );
    },
    ViewVitalRoute.name: (routeData) {
      final args = routeData.argsAs<ViewVitalRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ViewVitalScreen(
          key: args.key,
          vital: args.vital,
        ),
      );
    },
    ManualEntryRoute.name: (routeData) {
      final args = routeData.argsAs<ManualEntryRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ManualEntryScreen(
          key: args.key,
          vital: args.vital,
        ),
      );
    },
    HistoryDataRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HistoryDataScreen(),
      );
    },
    ViewWellnessRoute.name: (routeData) {
      final args = routeData.argsAs<ViewWellnessRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ViewWellnessScreen(
          key: args.key,
          vital: args.vital,
        ),
      );
    },
    MyAppRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MyAppScreen(),
      );
    },
    CalenderRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CalenderScreen(),
      );
    },
    CreateAppointmentRoute.name: (routeData) {
      final args = routeData.argsAs<CreateAppointmentRouteArgs>(
          orElse: () => const CreateAppointmentRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: CreateAppointmentScreen(
          key: args.key,
          appointment: args.appointment,
          isICalBool: args.isICalBool,
          ical: args.ical,
        ),
      );
    },
    GamesSelectionRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const GamesSelectionScreen(),
      );
    },
    GameRoute.name: (routeData) {
      final args = routeData.argsAs<GameRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: GameScreen(
          key: args.key,
          game: args.game,
        ),
      );
    },
    InternetRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const InternetScreen(),
      );
    },
    CalendarAppointmentRoute.name: (routeData) {
      final args = routeData.argsAs<CalendarAppointmentRouteArgs>(
          orElse: () => const CalendarAppointmentRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: CalendarAppointmentScreen(
          key: args.key,
          appointment: args.appointment,
          calEvent: args.calEvent,
          rem: args.rem,
          activityReminder: args.activityReminder,
        ),
      );
    },
    NewAppointmentRoute.name: (routeData) {
      final args = routeData.argsAs<NewAppointmentRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: NewAppointmentScreen(
          key: args.key,
          appointmentBloc: args.appointmentBloc,
        ),
      );
    },
    MedicationNotifyRoute.name: (routeData) {
      final args = routeData.argsAs<MedicationNotifyRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: MedicationNotifyScreen(
          key: args.key,
          notification: args.notification,
        ),
      );
    },
    AppointmentNotifyRoute.name: (routeData) {
      final args = routeData.argsAs<AppointmentNotifyRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: AppointmentNotifyScreen(
          key: args.key,
          notification: args.notification,
        ),
      );
    },
    LockRoute.name: (routeData) {
      final args =
          routeData.argsAs<LockRouteArgs>(orElse: () => const LockRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: LockScreen(key: args.key),
      );
    },
    MultipleUserRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MultipleUserScreen(),
      );
    },
    UserLoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const UserLoginScreen(),
      );
    },
    AddUserLoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const AddUserLoginScreen(),
      );
    },
    CareTeamRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CareTeamScreen(),
      );
    },
    MultipleChatUserRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MultipleChatUserScreen(),
      );
    },
    MemberHomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MemberHomeScreen(),
      );
    },
    WaitingRoomRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const WaitingRoomScreen(),
      );
    },
    VideoCallingRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const VideoCallingScreen(),
      );
    },
    FullVideoCallingRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const FullVideoCallingScreen(),
      );
    },
    WaitingRoomOverViewRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const WaitingRoomOverViewScreen(),
      );
    },
    LocalMedicationNotifyRoute.name: (routeData) {
      final args = routeData.argsAs<LocalMedicationNotifyRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: LocalMedicationNotifyScreen(
          key: args.key,
          medicationDetails: args.medicationDetails,
        ),
      );
    },
    AddEditMedicationRoute.name: (routeData) {
      final args = routeData.argsAs<AddEditMedicationRouteArgs>(
          orElse: () => const AddEditMedicationRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: AddEditMedicationScreen(
          key: args.key,
          medicine: args.medicine,
        ),
      );
    },
    IcalListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const IcalListScreen(),
      );
    },
    RssFeedRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RssFeedScreen(),
      );
    },
    CallingRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CallingScreen(),
      );
    },
    MoodTrackerRoute.name: (routeData) {
      final args = routeData.argsAs<MoodTrackerRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: MoodTrackerScreen(
          title: args.title,
          key: args.key,
        ),
      );
    },
    MoodTrackerOptionalRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MoodTrackerOptionalScreen(),
      );
    },
    MeetingViewRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MeetingViewScreen(),
      );
    },
    LoadingRoute.name: (routeData) {
      final args = routeData.argsAs<LoadingRouteArgs>(
          orElse: () => const LoadingRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: LoadingScreen(
          key: args.key,
          width: args.width,
          height: args.height,
        ),
      );
    },
    EducationRoute.name: (routeData) {
      final args = routeData.argsAs<EducationRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: EducationScreen(
          title: args.title,
          key: args.key,
        ),
      );
    },
    ExpandedEducationRoute.name: (routeData) {
      final args = routeData.argsAs<ExpandedEducationRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: ExpandedEducationScreen(
          key: args.key,
          feeds: args.feeds,
          educationFeedItem: args.educationFeedItem,
        ),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          HomeRoute.name,
          path: '/',
        ),
        RouteConfig(
          FCHomeRoute.name,
          path: '/f-chome-screen',
        ),
        RouteConfig(
          CustomerSupportHomeRoute.name,
          path: '/customer-support-home-screen',
        ),
        RouteConfig(
          ChatRoute.name,
          path: '/chat-screen',
        ),
        RouteConfig(
          FamilyMemoriesRoute.name,
          path: '/family-memories-screen',
        ),
        RouteConfig(
          ViewAlbumRoute.name,
          path: '/view-album-screen',
        ),
        RouteConfig(
          CreateAlbumRoute.name,
          path: '/create-album-screen',
        ),
        RouteConfig(
          MyMedicineRoute.name,
          path: '/my-medicine-screen',
        ),
        RouteConfig(
          MedicationDetailsRoute.name,
          path: '/medication-details-screen',
        ),
        RouteConfig(
          AddMedicationRoute.name,
          path: '/add-medication-screen',
        ),
        RouteConfig(
          HealthAndWellnessRoute.name,
          path: '/health-and-wellness-screen',
        ),
        RouteConfig(
          HealthyHabitsRoute.name,
          path: '/healthy-habits-screen',
        ),
        RouteConfig(
          IntakeHistoryRoute.name,
          path: '/intake-history-screen',
        ),
        RouteConfig(
          VitalsAndWellnessRoute.name,
          path: '/vitals-and-wellness-screen',
        ),
        RouteConfig(
          MyDevicesRoute.name,
          path: '/my-devices-screen',
        ),
        RouteConfig(
          AddDevicesRoute.name,
          path: '/add-devices-screen',
        ),
        RouteConfig(
          ViewVitalRoute.name,
          path: '/view-vital-screen',
        ),
        RouteConfig(
          ManualEntryRoute.name,
          path: '/manual-entry-screen',
        ),
        RouteConfig(
          HistoryDataRoute.name,
          path: '/history-data-screen',
        ),
        RouteConfig(
          ViewWellnessRoute.name,
          path: '/view-wellness-screen',
        ),
        RouteConfig(
          MyAppRoute.name,
          path: '/my-app-screen',
        ),
        RouteConfig(
          CalenderRoute.name,
          path: '/calender-screen',
        ),
        RouteConfig(
          CreateAppointmentRoute.name,
          path: '/create-appointment-screen',
        ),
        RouteConfig(
          GamesSelectionRoute.name,
          path: '/games-selection-screen',
        ),
        RouteConfig(
          GameRoute.name,
          path: '/game-screen',
        ),
        RouteConfig(
          InternetRoute.name,
          path: '/internet-screen',
        ),
        RouteConfig(
          CalendarAppointmentRoute.name,
          path: '/calendar-appointment-screen',
        ),
        RouteConfig(
          NewAppointmentRoute.name,
          path: '/new-appointment-screen',
        ),
        RouteConfig(
          MedicationNotifyRoute.name,
          path: '/medication-notify-screen',
        ),
        RouteConfig(
          AppointmentNotifyRoute.name,
          path: '/appointment-notify-screen',
        ),
        RouteConfig(
          LockRoute.name,
          path: '/lock-screen',
        ),
        RouteConfig(
          MultipleUserRoute.name,
          path: '/multiple-user-screen',
        ),
        RouteConfig(
          UserLoginRoute.name,
          path: '/user-login-screen',
        ),
        RouteConfig(
          AddUserLoginRoute.name,
          path: '/add-user-login-screen',
        ),
        RouteConfig(
          CareTeamRoute.name,
          path: '/care-team-screen',
        ),
        RouteConfig(
          MultipleChatUserRoute.name,
          path: '/multiple-chat-user-screen',
        ),
        RouteConfig(
          MemberHomeRoute.name,
          path: '/member-home-screen',
        ),
        RouteConfig(
          WaitingRoomRoute.name,
          path: '/waiting-room-screen',
        ),
        RouteConfig(
          VideoCallingRoute.name,
          path: '/video-calling-screen',
        ),
        RouteConfig(
          FullVideoCallingRoute.name,
          path: '/full-video-calling-screen',
        ),
        RouteConfig(
          WaitingRoomOverViewRoute.name,
          path: '/waiting-room-over-view-screen',
        ),
        RouteConfig(
          LocalMedicationNotifyRoute.name,
          path: '/local-medication-notify-screen',
        ),
        RouteConfig(
          AddEditMedicationRoute.name,
          path: '/add-edit-medication-screen',
        ),
        RouteConfig(
          IcalListRoute.name,
          path: '/ical-list-screen',
        ),
        RouteConfig(
          RssFeedRoute.name,
          path: '/rss-feed-screen',
        ),
        RouteConfig(
          CallingRoute.name,
          path: '/calling-screen',
        ),
        RouteConfig(
          MoodTrackerRoute.name,
          path: '/mood-tracker-screen',
        ),
        RouteConfig(
          MoodTrackerOptionalRoute.name,
          path: '/mood-tracker-optional-screen',
        ),
        RouteConfig(
          MeetingViewRoute.name,
          path: '/meeting-view-screen',
        ),
        RouteConfig(
          LoadingRoute.name,
          path: '/loading-screen',
        ),
        RouteConfig(
          EducationRoute.name,
          path: '/education-screen',
        ),
        RouteConfig(
          ExpandedEducationRoute.name,
          path: '/expanded-education-screen',
        ),
      ];
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [FCHomeScreen]
class FCHomeRoute extends PageRouteInfo<void> {
  const FCHomeRoute()
      : super(
          FCHomeRoute.name,
          path: '/f-chome-screen',
        );

  static const String name = 'FCHomeRoute';
}

/// generated route for
/// [CustomerSupportHomeScreen]
class CustomerSupportHomeRoute extends PageRouteInfo<void> {
  const CustomerSupportHomeRoute()
      : super(
          CustomerSupportHomeRoute.name,
          path: '/customer-support-home-screen',
        );

  static const String name = 'CustomerSupportHomeRoute';
}

/// generated route for
/// [ChatScreen]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    bool shouldOpenSession = false,
  }) : super(
          ChatRoute.name,
          path: '/chat-screen',
          args: ChatRouteArgs(
            key: key,
            shouldOpenSession: shouldOpenSession,
          ),
        );

  static const String name = 'ChatRoute';
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    this.shouldOpenSession = false,
  });

  final Key? key;

  final bool shouldOpenSession;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, shouldOpenSession: $shouldOpenSession}';
  }
}

/// generated route for
/// [FamilyMemoriesScreen]
class FamilyMemoriesRoute extends PageRouteInfo<void> {
  const FamilyMemoriesRoute()
      : super(
          FamilyMemoriesRoute.name,
          path: '/family-memories-screen',
        );

  static const String name = 'FamilyMemoriesRoute';
}

/// generated route for
/// [ViewAlbumScreen]
class ViewAlbumRoute extends PageRouteInfo<void> {
  const ViewAlbumRoute()
      : super(
          ViewAlbumRoute.name,
          path: '/view-album-screen',
        );

  static const String name = 'ViewAlbumRoute';
}

/// generated route for
/// [CreateAlbumScreen]
class CreateAlbumRoute extends PageRouteInfo<void> {
  const CreateAlbumRoute()
      : super(
          CreateAlbumRoute.name,
          path: '/create-album-screen',
        );

  static const String name = 'CreateAlbumRoute';
}

/// generated route for
/// [MyMedicineScreen]
class MyMedicineRoute extends PageRouteInfo<void> {
  const MyMedicineRoute()
      : super(
          MyMedicineRoute.name,
          path: '/my-medicine-screen',
        );

  static const String name = 'MyMedicineRoute';
}

/// generated route for
/// [MedicationDetailsScreen]
class MedicationDetailsRoute extends PageRouteInfo<void> {
  const MedicationDetailsRoute()
      : super(
          MedicationDetailsRoute.name,
          path: '/medication-details-screen',
        );

  static const String name = 'MedicationDetailsRoute';
}

/// generated route for
/// [AddMedicationScreen]
class AddMedicationRoute extends PageRouteInfo<AddMedicationRouteArgs> {
  AddMedicationRoute({
    Key? key,
    bool fromEditing = false,
    MedicationState? medicationStateForEditing,
  }) : super(
          AddMedicationRoute.name,
          path: '/add-medication-screen',
          args: AddMedicationRouteArgs(
            key: key,
            fromEditing: fromEditing,
            medicationStateForEditing: medicationStateForEditing,
          ),
        );

  static const String name = 'AddMedicationRoute';
}

class AddMedicationRouteArgs {
  const AddMedicationRouteArgs({
    this.key,
    this.fromEditing = false,
    this.medicationStateForEditing,
  });

  final Key? key;

  final bool fromEditing;

  final MedicationState? medicationStateForEditing;

  @override
  String toString() {
    return 'AddMedicationRouteArgs{key: $key, fromEditing: $fromEditing, medicationStateForEditing: $medicationStateForEditing}';
  }
}

/// generated route for
/// [HealthAndWellnessScreen]
class HealthAndWellnessRoute extends PageRouteInfo<void> {
  const HealthAndWellnessRoute()
      : super(
          HealthAndWellnessRoute.name,
          path: '/health-and-wellness-screen',
        );

  static const String name = 'HealthAndWellnessRoute';
}

/// generated route for
/// [HealthyHabitsScreen]
class HealthyHabitsRoute extends PageRouteInfo<void> {
  const HealthyHabitsRoute()
      : super(
          HealthyHabitsRoute.name,
          path: '/healthy-habits-screen',
        );

  static const String name = 'HealthyHabitsRoute';
}

/// generated route for
/// [IntakeHistoryScreen]
class IntakeHistoryRoute extends PageRouteInfo<void> {
  const IntakeHistoryRoute()
      : super(
          IntakeHistoryRoute.name,
          path: '/intake-history-screen',
        );

  static const String name = 'IntakeHistoryRoute';
}

/// generated route for
/// [VitalsAndWellnessScreen]
class VitalsAndWellnessRoute extends PageRouteInfo<void> {
  const VitalsAndWellnessRoute()
      : super(
          VitalsAndWellnessRoute.name,
          path: '/vitals-and-wellness-screen',
        );

  static const String name = 'VitalsAndWellnessRoute';
}

/// generated route for
/// [MyDevicesScreen]
class MyDevicesRoute extends PageRouteInfo<void> {
  const MyDevicesRoute()
      : super(
          MyDevicesRoute.name,
          path: '/my-devices-screen',
        );

  static const String name = 'MyDevicesRoute';
}

/// generated route for
/// [AddDevicesScreen]
class AddDevicesRoute extends PageRouteInfo<void> {
  const AddDevicesRoute()
      : super(
          AddDevicesRoute.name,
          path: '/add-devices-screen',
        );

  static const String name = 'AddDevicesRoute';
}

/// generated route for
/// [ViewVitalScreen]
class ViewVitalRoute extends PageRouteInfo<ViewVitalRouteArgs> {
  ViewVitalRoute({
    Key? key,
    required Vital vital,
  }) : super(
          ViewVitalRoute.name,
          path: '/view-vital-screen',
          args: ViewVitalRouteArgs(
            key: key,
            vital: vital,
          ),
        );

  static const String name = 'ViewVitalRoute';
}

class ViewVitalRouteArgs {
  const ViewVitalRouteArgs({
    this.key,
    required this.vital,
  });

  final Key? key;

  final Vital vital;

  @override
  String toString() {
    return 'ViewVitalRouteArgs{key: $key, vital: $vital}';
  }
}

/// generated route for
/// [ManualEntryScreen]
class ManualEntryRoute extends PageRouteInfo<ManualEntryRouteArgs> {
  ManualEntryRoute({
    Key? key,
    required Vital vital,
  }) : super(
          ManualEntryRoute.name,
          path: '/manual-entry-screen',
          args: ManualEntryRouteArgs(
            key: key,
            vital: vital,
          ),
        );

  static const String name = 'ManualEntryRoute';
}

class ManualEntryRouteArgs {
  const ManualEntryRouteArgs({
    this.key,
    required this.vital,
  });

  final Key? key;

  final Vital vital;

  @override
  String toString() {
    return 'ManualEntryRouteArgs{key: $key, vital: $vital}';
  }
}

/// generated route for
/// [HistoryDataScreen]
class HistoryDataRoute extends PageRouteInfo<void> {
  const HistoryDataRoute()
      : super(
          HistoryDataRoute.name,
          path: '/history-data-screen',
        );

  static const String name = 'HistoryDataRoute';
}

/// generated route for
/// [ViewWellnessScreen]
class ViewWellnessRoute extends PageRouteInfo<ViewWellnessRouteArgs> {
  ViewWellnessRoute({
    Key? key,
    required Vital vital,
  }) : super(
          ViewWellnessRoute.name,
          path: '/view-wellness-screen',
          args: ViewWellnessRouteArgs(
            key: key,
            vital: vital,
          ),
        );

  static const String name = 'ViewWellnessRoute';
}

class ViewWellnessRouteArgs {
  const ViewWellnessRouteArgs({
    this.key,
    required this.vital,
  });

  final Key? key;

  final Vital vital;

  @override
  String toString() {
    return 'ViewWellnessRouteArgs{key: $key, vital: $vital}';
  }
}

/// generated route for
/// [MyAppScreen]
class MyAppRoute extends PageRouteInfo<void> {
  const MyAppRoute()
      : super(
          MyAppRoute.name,
          path: '/my-app-screen',
        );

  static const String name = 'MyAppRoute';
}

/// generated route for
/// [CalenderScreen]
class CalenderRoute extends PageRouteInfo<void> {
  const CalenderRoute()
      : super(
          CalenderRoute.name,
          path: '/calender-screen',
        );

  static const String name = 'CalenderRoute';
}

/// generated route for
/// [CreateAppointmentScreen]
class CreateAppointmentRoute extends PageRouteInfo<CreateAppointmentRouteArgs> {
  CreateAppointmentRoute({
    Key? key,
    Reminders? appointment,
    bool? isICalBool,
    ICalURL? ical,
  }) : super(
          CreateAppointmentRoute.name,
          path: '/create-appointment-screen',
          args: CreateAppointmentRouteArgs(
            key: key,
            appointment: appointment,
            isICalBool: isICalBool,
            ical: ical,
          ),
        );

  static const String name = 'CreateAppointmentRoute';
}

class CreateAppointmentRouteArgs {
  const CreateAppointmentRouteArgs({
    this.key,
    this.appointment,
    this.isICalBool,
    this.ical,
  });

  final Key? key;

  final Reminders? appointment;

  final bool? isICalBool;

  final ICalURL? ical;

  @override
  String toString() {
    return 'CreateAppointmentRouteArgs{key: $key, appointment: $appointment, isICalBool: $isICalBool, ical: $ical}';
  }
}

/// generated route for
/// [GamesSelectionScreen]
class GamesSelectionRoute extends PageRouteInfo<void> {
  const GamesSelectionRoute()
      : super(
          GamesSelectionRoute.name,
          path: '/games-selection-screen',
        );

  static const String name = 'GamesSelectionRoute';
}

/// generated route for
/// [GameScreen]
class GameRoute extends PageRouteInfo<GameRouteArgs> {
  GameRoute({
    Key? key,
    required Game game,
  }) : super(
          GameRoute.name,
          path: '/game-screen',
          args: GameRouteArgs(
            key: key,
            game: game,
          ),
        );

  static const String name = 'GameRoute';
}

class GameRouteArgs {
  const GameRouteArgs({
    this.key,
    required this.game,
  });

  final Key? key;

  final Game game;

  @override
  String toString() {
    return 'GameRouteArgs{key: $key, game: $game}';
  }
}

/// generated route for
/// [InternetScreen]
class InternetRoute extends PageRouteInfo<void> {
  const InternetRoute()
      : super(
          InternetRoute.name,
          path: '/internet-screen',
        );

  static const String name = 'InternetRoute';
}

/// generated route for
/// [CalendarAppointmentScreen]
class CalendarAppointmentRoute
    extends PageRouteInfo<CalendarAppointmentRouteArgs> {
  CalendarAppointmentRoute({
    Key? key,
    Appointment? appointment,
    CalendarEventData<Object?>? calEvent,
    Reminders? rem,
    ActivityReminder? activityReminder,
  }) : super(
          CalendarAppointmentRoute.name,
          path: '/calendar-appointment-screen',
          args: CalendarAppointmentRouteArgs(
            key: key,
            appointment: appointment,
            calEvent: calEvent,
            rem: rem,
            activityReminder: activityReminder,
          ),
        );

  static const String name = 'CalendarAppointmentRoute';
}

class CalendarAppointmentRouteArgs {
  const CalendarAppointmentRouteArgs({
    this.key,
    this.appointment,
    this.calEvent,
    this.rem,
    this.activityReminder,
  });

  final Key? key;

  final Appointment? appointment;

  final CalendarEventData<Object?>? calEvent;

  final Reminders? rem;

  final ActivityReminder? activityReminder;

  @override
  String toString() {
    return 'CalendarAppointmentRouteArgs{key: $key, appointment: $appointment, calEvent: $calEvent, rem: $rem, activityReminder: $activityReminder}';
  }
}

/// generated route for
/// [NewAppointmentScreen]
class NewAppointmentRoute extends PageRouteInfo<NewAppointmentRouteArgs> {
  NewAppointmentRoute({
    Key? key,
    required ManageAppointmentBloc appointmentBloc,
  }) : super(
          NewAppointmentRoute.name,
          path: '/new-appointment-screen',
          args: NewAppointmentRouteArgs(
            key: key,
            appointmentBloc: appointmentBloc,
          ),
        );

  static const String name = 'NewAppointmentRoute';
}

class NewAppointmentRouteArgs {
  const NewAppointmentRouteArgs({
    this.key,
    required this.appointmentBloc,
  });

  final Key? key;

  final ManageAppointmentBloc appointmentBloc;

  @override
  String toString() {
    return 'NewAppointmentRouteArgs{key: $key, appointmentBloc: $appointmentBloc}';
  }
}

/// generated route for
/// [MedicationNotifyScreen]
class MedicationNotifyRoute extends PageRouteInfo<MedicationNotifyRouteArgs> {
  MedicationNotifyRoute({
    Key? key,
    required app.Notification notification,
  }) : super(
          MedicationNotifyRoute.name,
          path: '/medication-notify-screen',
          args: MedicationNotifyRouteArgs(
            key: key,
            notification: notification,
          ),
        );

  static const String name = 'MedicationNotifyRoute';
}

class MedicationNotifyRouteArgs {
  const MedicationNotifyRouteArgs({
    this.key,
    required this.notification,
  });

  final Key? key;

  final app.Notification notification;

  @override
  String toString() {
    return 'MedicationNotifyRouteArgs{key: $key, notification: $notification}';
  }
}

/// generated route for
/// [AppointmentNotifyScreen]
class AppointmentNotifyRoute extends PageRouteInfo<AppointmentNotifyRouteArgs> {
  AppointmentNotifyRoute({
    Key? key,
    required app.Notification notification,
  }) : super(
          AppointmentNotifyRoute.name,
          path: '/appointment-notify-screen',
          args: AppointmentNotifyRouteArgs(
            key: key,
            notification: notification,
          ),
        );

  static const String name = 'AppointmentNotifyRoute';
}

class AppointmentNotifyRouteArgs {
  const AppointmentNotifyRouteArgs({
    this.key,
    required this.notification,
  });

  final Key? key;

  final app.Notification notification;

  @override
  String toString() {
    return 'AppointmentNotifyRouteArgs{key: $key, notification: $notification}';
  }
}

/// generated route for
/// [LockScreen]
class LockRoute extends PageRouteInfo<LockRouteArgs> {
  LockRoute({Key? key})
      : super(
          LockRoute.name,
          path: '/lock-screen',
          args: LockRouteArgs(key: key),
        );

  static const String name = 'LockRoute';
}

class LockRouteArgs {
  const LockRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'LockRouteArgs{key: $key}';
  }
}

/// generated route for
/// [MultipleUserScreen]
class MultipleUserRoute extends PageRouteInfo<void> {
  const MultipleUserRoute()
      : super(
          MultipleUserRoute.name,
          path: '/multiple-user-screen',
        );

  static const String name = 'MultipleUserRoute';
}

/// generated route for
/// [UserLoginScreen]
class UserLoginRoute extends PageRouteInfo<void> {
  const UserLoginRoute()
      : super(
          UserLoginRoute.name,
          path: '/user-login-screen',
        );

  static const String name = 'UserLoginRoute';
}

/// generated route for
/// [AddUserLoginScreen]
class AddUserLoginRoute extends PageRouteInfo<void> {
  const AddUserLoginRoute()
      : super(
          AddUserLoginRoute.name,
          path: '/add-user-login-screen',
        );

  static const String name = 'AddUserLoginRoute';
}

/// generated route for
/// [CareTeamScreen]
class CareTeamRoute extends PageRouteInfo<void> {
  const CareTeamRoute()
      : super(
          CareTeamRoute.name,
          path: '/care-team-screen',
        );

  static const String name = 'CareTeamRoute';
}

/// generated route for
/// [MultipleChatUserScreen]
class MultipleChatUserRoute extends PageRouteInfo<void> {
  const MultipleChatUserRoute()
      : super(
          MultipleChatUserRoute.name,
          path: '/multiple-chat-user-screen',
        );

  static const String name = 'MultipleChatUserRoute';
}

/// generated route for
/// [MemberHomeScreen]
class MemberHomeRoute extends PageRouteInfo<void> {
  const MemberHomeRoute()
      : super(
          MemberHomeRoute.name,
          path: '/member-home-screen',
        );

  static const String name = 'MemberHomeRoute';
}

/// generated route for
/// [WaitingRoomScreen]
class WaitingRoomRoute extends PageRouteInfo<void> {
  const WaitingRoomRoute()
      : super(
          WaitingRoomRoute.name,
          path: '/waiting-room-screen',
        );

  static const String name = 'WaitingRoomRoute';
}

/// generated route for
/// [VideoCallingScreen]
class VideoCallingRoute extends PageRouteInfo<void> {
  const VideoCallingRoute()
      : super(
          VideoCallingRoute.name,
          path: '/video-calling-screen',
        );

  static const String name = 'VideoCallingRoute';
}

/// generated route for
/// [FullVideoCallingScreen]
class FullVideoCallingRoute extends PageRouteInfo<void> {
  const FullVideoCallingRoute()
      : super(
          FullVideoCallingRoute.name,
          path: '/full-video-calling-screen',
        );

  static const String name = 'FullVideoCallingRoute';
}

/// generated route for
/// [WaitingRoomOverViewScreen]
class WaitingRoomOverViewRoute extends PageRouteInfo<void> {
  const WaitingRoomOverViewRoute()
      : super(
          WaitingRoomOverViewRoute.name,
          path: '/waiting-room-over-view-screen',
        );

  static const String name = 'WaitingRoomOverViewRoute';
}

/// generated route for
/// [LocalMedicationNotifyScreen]
class LocalMedicationNotifyRoute
    extends PageRouteInfo<LocalMedicationNotifyRouteArgs> {
  LocalMedicationNotifyRoute({
    Key? key,
    required SelectedMedicationDetails medicationDetails,
  }) : super(
          LocalMedicationNotifyRoute.name,
          path: '/local-medication-notify-screen',
          args: LocalMedicationNotifyRouteArgs(
            key: key,
            medicationDetails: medicationDetails,
          ),
        );

  static const String name = 'LocalMedicationNotifyRoute';
}

class LocalMedicationNotifyRouteArgs {
  const LocalMedicationNotifyRouteArgs({
    this.key,
    required this.medicationDetails,
  });

  final Key? key;

  final SelectedMedicationDetails medicationDetails;

  @override
  String toString() {
    return 'LocalMedicationNotifyRouteArgs{key: $key, medicationDetails: $medicationDetails}';
  }
}

/// generated route for
/// [AddEditMedicationScreen]
class AddEditMedicationRoute extends PageRouteInfo<AddEditMedicationRouteArgs> {
  AddEditMedicationRoute({
    Key? key,
    SelectedMedicationDetails? medicine,
  }) : super(
          AddEditMedicationRoute.name,
          path: '/add-edit-medication-screen',
          args: AddEditMedicationRouteArgs(
            key: key,
            medicine: medicine,
          ),
        );

  static const String name = 'AddEditMedicationRoute';
}

class AddEditMedicationRouteArgs {
  const AddEditMedicationRouteArgs({
    this.key,
    this.medicine,
  });

  final Key? key;

  final SelectedMedicationDetails? medicine;

  @override
  String toString() {
    return 'AddEditMedicationRouteArgs{key: $key, medicine: $medicine}';
  }
}

/// generated route for
/// [IcalListScreen]
class IcalListRoute extends PageRouteInfo<void> {
  const IcalListRoute()
      : super(
          IcalListRoute.name,
          path: '/ical-list-screen',
        );

  static const String name = 'IcalListRoute';
}

/// generated route for
/// [RssFeedScreen]
class RssFeedRoute extends PageRouteInfo<void> {
  const RssFeedRoute()
      : super(
          RssFeedRoute.name,
          path: '/rss-feed-screen',
        );

  static const String name = 'RssFeedRoute';
}

/// generated route for
/// [CallingScreen]
class CallingRoute extends PageRouteInfo<void> {
  const CallingRoute()
      : super(
          CallingRoute.name,
          path: '/calling-screen',
        );

  static const String name = 'CallingRoute';
}

/// generated route for
/// [MoodTrackerScreen]
class MoodTrackerRoute extends PageRouteInfo<MoodTrackerRouteArgs> {
  MoodTrackerRoute({
    required String title,
    Key? key,
  }) : super(
          MoodTrackerRoute.name,
          path: '/mood-tracker-screen',
          args: MoodTrackerRouteArgs(
            title: title,
            key: key,
          ),
        );

  static const String name = 'MoodTrackerRoute';
}

class MoodTrackerRouteArgs {
  const MoodTrackerRouteArgs({
    required this.title,
    this.key,
  });

  final String title;

  final Key? key;

  @override
  String toString() {
    return 'MoodTrackerRouteArgs{title: $title, key: $key}';
  }
}

/// generated route for
/// [MoodTrackerOptionalScreen]
class MoodTrackerOptionalRoute extends PageRouteInfo<void> {
  const MoodTrackerOptionalRoute()
      : super(
          MoodTrackerOptionalRoute.name,
          path: '/mood-tracker-optional-screen',
        );

  static const String name = 'MoodTrackerOptionalRoute';
}

/// generated route for
/// [MeetingViewScreen]
class MeetingViewRoute extends PageRouteInfo<void> {
  const MeetingViewRoute()
      : super(
          MeetingViewRoute.name,
          path: '/meeting-view-screen',
        );

  static const String name = 'MeetingViewRoute';
}

/// generated route for
/// [LoadingScreen]
class LoadingRoute extends PageRouteInfo<LoadingRouteArgs> {
  LoadingRoute({
    Key? key,
    double? width,
    double? height,
  }) : super(
          LoadingRoute.name,
          path: '/loading-screen',
          args: LoadingRouteArgs(
            key: key,
            width: width,
            height: height,
          ),
        );

  static const String name = 'LoadingRoute';
}

class LoadingRouteArgs {
  const LoadingRouteArgs({
    this.key,
    this.width,
    this.height,
  });

  final Key? key;

  final double? width;

  final double? height;

  @override
  String toString() {
    return 'LoadingRouteArgs{key: $key, width: $width, height: $height}';
  }
}

/// generated route for
/// [EducationScreen]
class EducationRoute extends PageRouteInfo<EducationRouteArgs> {
  EducationRoute({
    required String title,
    Key? key,
  }) : super(
          EducationRoute.name,
          path: '/education-screen',
          args: EducationRouteArgs(
            title: title,
            key: key,
          ),
        );

  static const String name = 'EducationRoute';
}

class EducationRouteArgs {
  const EducationRouteArgs({
    required this.title,
    this.key,
  });

  final String title;

  final Key? key;

  @override
  String toString() {
    return 'EducationRouteArgs{title: $title, key: $key}';
  }
}

/// generated route for
/// [ExpandedEducationScreen]
class ExpandedEducationRoute extends PageRouteInfo<ExpandedEducationRouteArgs> {
  ExpandedEducationRoute({
    Key? key,
    required List<RssFeedItem> feeds,
    required EducationType educationFeedItem,
  }) : super(
          ExpandedEducationRoute.name,
          path: '/expanded-education-screen',
          args: ExpandedEducationRouteArgs(
            key: key,
            feeds: feeds,
            educationFeedItem: educationFeedItem,
          ),
        );

  static const String name = 'ExpandedEducationRoute';
}

class ExpandedEducationRouteArgs {
  const ExpandedEducationRouteArgs({
    this.key,
    required this.feeds,
    required this.educationFeedItem,
  });

  final Key? key;

  final List<RssFeedItem> feeds;

  final EducationType educationFeedItem;

  @override
  String toString() {
    return 'ExpandedEducationRouteArgs{key: $key, feeds: $feeds, educationFeedItem: $educationFeedItem}';
  }
}
