part of 'kiosk_dashboard_bloc.dart';


// class MasterDashboardState{
//   final Map<int, KioskDashboardState> dashboards;
//   final int currentDashboard;
// }

class KioskDashboardState extends Equatable {
  final List<MainModuleItem> mainModuleItems;
  final MainModuleInfo mainModuleInfo;
  final List<SubModuleItem> subModuleItems;
  final SubModuleInfo subModuleInfo;
  final Map<int, List<SubModuleLink>> subModuleLinks;
  final int dashboardId;
  final Response themeDataJson;
  // final List<Map<String, String>> map;
  final List<RssFeedItem> feeds;
  Status status;
  final int showFeeds;
  final String logo;
  final Color secondaryColor;
  final Color primaryColor;
  final String background;
  KioskDashboardState( {
    // required this.map,
    required this.secondaryColor, required this.primaryColor,
    required this.background,
    required this.mainModuleItems,
    required this.mainModuleInfo,
    required this.subModuleItems,
    required this.subModuleInfo,
    required this.subModuleLinks,
    required this.dashboardId,
    required this.status,
    required this.themeDataJson,
    required this.feeds,
    required this.showFeeds,
    required this.logo,
  });

  factory KioskDashboardState.initial() {
    return KioskDashboardState(
        mainModuleItems: [],
        mainModuleInfo: MainModuleInfo(info: []),
        subModuleItems: [],
        subModuleInfo: SubModuleInfo(info: []),
        subModuleLinks: {},
        dashboardId: 0,
        // map: [
        //   {
        //     'title': 'Hearing loss prevalence and years lived with disability',
        //     'desc':
        //         'Hearing loss affects access to spoken language, which can affect cognition and development, ',
        //     'date': '2 September 2023',
        //     'timeAgo': '5 days ago',
        //     'image': 'assets/story_image1.png',
        //   },
        //   {
        //     'title': 'Am I really fit?',
        //     'desc':
        //         'Jogging is a form of trotting or running at a slow or leisurely pace. The main intention is to increase physical fitness with less stress on the body than from faster running but more than walking, or to maintain a steady speed for longer periods of time. Performed over long distances, it is a form of aerobic endurance training.',
        //     'date': '13 August 2023',
        //     'timeAgo': '20 days ago',
        //     'image': 'assets/story_image3.png',
        //   },
        //   {
        //     'title': 'Stay Positive, Stay Strong !!',
        //     'desc':
        //         'Like sunlit blooms on weathered walls, find joy in small things. Be windswept willow, bend but never break. Stay happy, stay strong, the path your own to make.',
        //     'date': '31 July 2023',
        //     'timeAgo': '33 days ago',
        //     'image': 'assets/story_image4.png',
        //   },
        //   {
        //     'title': 'Motherhood !!',
        //     'desc':
        //         'Hearts beat in tandem, one borrowed, one new. Love cradles chaos, whispers through sleepless nights. Roots grow strong, nurturing wings to take flight.',
        //     'date': '15 July 2023',
        //     'timeAgo': '45 days ago',
        //     'image': 'assets/story_image5.png',
        //   },
        //   {
        //     'title': 'Hearing Impairment Disability Definition and Types',
        //     'desc':
        //         'A pure tone audiometry test measures the softest, or least audible, sound that a person can hear.',
        //     'date': '22 August 2023',
        //     'timeAgo': '10 days ago',
        //     'image': 'assets/story_image2.png',
        //   },
        //   {
        //     'title': 'Hearing Impairment Disability Definition and Types',
        //     'desc':
        //         'A pure tone audiometry test measures the softest, or least audible, sound that a person can hear.',
        //     'date': '22 August 2023',
        //     'timeAgo': '10 days ago',
        //     'image': 'assets/story_image2.png',
        //   },
        //   {
        //     'title': 'Hearing Impairment Disability Definition and Types',
        //     'desc':
        //         'A pure tone audiometry test measures the softest, or least audible, sound that a person can hear.',
        //     'date': '22 August 2023',
        //     'timeAgo': '10 days ago',
        //     'image': 'assets/story_image2.png',
        //   },
        //   {
        //     'title': 'Hearing Impairment Disability Definition and Types',
        //     'desc':
        //         'A pure tone audiometry test measures the softest, or least audible, sound that a person can hear.',
        //     'date': '22 August 2023',
        //     'timeAgo': '10 days ago',
        //     'image': 'assets/story_image2.png',
        //   },
        //   {
        //     'title': 'Hearing Impairment Disability Definition and Types',
        //     'desc':
        //         'A pure tone audiometry test measures the softest, or least audible, sound that a person can hear.',
        //     'date': '22 August 2023',
        //     'timeAgo': '10 days ago',
        //     'image': 'assets/story_image2.png',
        //   },
        // ],
        status: Status.initial,
        themeDataJson: Response("", 404),
        feeds: [],
        showFeeds: 0, secondaryColor: Colors.black, primaryColor: Colors.white, background: "", logo : "");
  }

  KioskDashboardState copyWith({
    List<MainModuleItem>? mainModuleItems,
    MainModuleInfo? mainModuleInfo,
    List<SubModuleItem>? subModuleItems,
    SubModuleInfo? subModuleInfo,
    Map<int, List<SubModuleLink>>? subModuleLinks,
    int? dashboardId,
    Status? status,
    Response? themeDataJson,
    List<Map<String, String>>? map,
    List<RssFeedItem>? feeds,
    int? showFeeds,
    String? background, String? logo, Color? primaryColor, Color ? secondaryColor
  }) {
    return KioskDashboardState(
        themeDataJson: themeDataJson ?? this.themeDataJson,
        // map: map ?? this.map,
        mainModuleItems: mainModuleItems ?? this.mainModuleItems,
        mainModuleInfo: mainModuleInfo ?? this.mainModuleInfo,
        subModuleItems: subModuleItems ?? this.subModuleItems,
        subModuleInfo: subModuleInfo ?? this.subModuleInfo,
        subModuleLinks: subModuleLinks ?? this.subModuleLinks,
        dashboardId: dashboardId ?? this.dashboardId,
        status: status ?? this.status,
        feeds: feeds ?? this.feeds,
        showFeeds: showFeeds ?? this.showFeeds, secondaryColor: secondaryColor ?? this.secondaryColor, primaryColor: primaryColor ?? this.primaryColor,
        background: background ?? this.background,
        logo: logo ?? this.logo

    );
  }

  List<Object?> get props => [
    mainModuleInfo,
    mainModuleItems,
    subModuleItems,
    subModuleInfo,
    subModuleLinks,
    dashboardId,
    status,
    themeDataJson,
    feeds,
    showFeeds,
    logo,
    background,
    primaryColor,
    secondaryColor
  ];
}
