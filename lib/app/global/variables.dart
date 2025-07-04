import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_api/user_api.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppVariables {
  // App global variables and constants
  static const String appName = 'Tiki Taka Scoreboard';
  static const String appUserModelId = 'tiki_taka_scoreboard_desktop';
  static const String appGUID = '657a64f1-ca4c-4e93-a5a3-b7ad2ce3a393';
  final TextStyle appGlobalFont = GoogleFonts.quicksand();
  final TextStyle appTitleFont = GoogleFonts.spaceGrotesk().copyWith(
    fontWeight: FontWeight.bold,
    fontSize: titleSize,
  );
  final TextStyle appScoreboardFont = GoogleFonts.viga().copyWith(
    fontWeight: FontWeight.bold,
    fontSize: matchStatusSize,
  );

  static const int numberOfShimmers = 10;
  static const double scrollMagnitude = 10;
  static const Duration scrollDuration = Duration(milliseconds: 600);
  static const double scrollWidth = 5;
  static const double titleSize = 30;
  static const double subtitleSize = 12;
  static const double matchStatusSize = 35;
  static const Color defaultColor = Colors.transparent;
  static const colorMap = <String, Color>{
    'Black': Color(0xFF000000),
    'Blue': Color(0xFF0078D7),
    'Brown': Color(0xFF795548),
    'Claret': Color(0xFF7F1734),
    'Cyan': Color(0xFF00BCD4),
    'Dark Blue': Color(0xFF3F51B5),
    'Gold': Color(0xFFFFD700),
    'Green': Color(0xFF107C10),
    'Light Blue': Color(0xFF03A9F4),
    'Maroon': Color(0xFF800000),
    'Navy Blue': Color(0xFF000080),
    'Orange': Color(0xFFF7630C),
    'Purple': Color(0xFF881798),
    'Red': Color(0xFFE81123),
    'Royal Blue': Color(0xFF4169E1),
    'Sky Blue': Color(0xFF80D8FF),
    'Violet': Color(0xFF673AB7),
    'White': Color(0xFFFFFFFF),
    'Yellow': Color(0xFFFFB900),
  };

  // Firestore collections
  static const String matchesCollection = 'matches';
  static const String configsCollection = 'configs';
  static const String leaguesCollection = 'leagues';
  static const String standingsCollection = 'standings';
  static const String teamsCollection = 'teams';
  static const String devicesCollection = 'devices';
  static const String notificationsCollection = 'notifications';

  // Firestore fields
  static const String utcDate = 'utcDate';
  static const String emptyLeague = '';

  // Firebase Messaging topics
  static const String allDevicesTopic = 'all-devices';
  static const String wearOSTopic = 'platform-wearos';
  static const String macOSTopic = 'platform-macos';
  static const String windowsTopic = 'platform-windows';

  // Notification types
  static const String notificationTypeGoalHome = 'GOAL_HOME';
  static const String notificationTypeGoalAway = 'GOAL_AWAY';
  static const String notificationTypeMatchStatus = 'MATCH_STATUS';

  // Demo notification
  final AppMessage demoNotification = AppMessage(
    senderId: 'backend-service',
    collapseKey: 'demo_notification',
    from: 'backend-service',
    messageId: 'demo_notification_001',
    messageType: 'notification',
    notification: const AppNotification(
      title: '¡Gol de FC Barcelona! ⚽',
      body: '🔴🔵 Barça 4️⃣ - 3️⃣ Real Madrid ⚪⚪',
      channelId: 'high_importance_channel',
      clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      color: '#FF0000',
      count: 1,
      imageUrl: 'https://picsum.photos/id/11/300',
      priority: NotificationPriority.highPriority,
      ticker: 'Demo Ticker',
      visibility: NotificationVisibility.public,
      tag: 'demo_notification_tag',
    ),
    sentTime: DateTime.now(),
    data: const {
      'match': 'matchId:498957',
    },
  );
}
