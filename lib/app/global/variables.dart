import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_api/user_api.dart';

// App global variables and constants
const String appName = 'Tiki Taka Scoreboard';
const String appUserModelId = 'tiki_taka_scoreboard_desktop';
const String appGUID = '657a64f1-ca4c-4e93-a5a3-b7ad2ce3a393';
final TextStyle appFont = GoogleFonts.montserrat();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const int numberOfShimmers = 5;
const double scrollMagnitude = 10;
const Duration scrollDuration = Duration(milliseconds: 600);
const double scrollWidth = 5;
const double titleSize = 18;
const Color defaultColor = Colors.transparent;
const colorMap = <String, Color>{
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
const String matchesCollection = 'matches';
const String configsCollection = 'configs';
const String leaguesCollection = 'leagues';
const String standingsCollection = 'standings';
const String teamsCollection = 'teams';
const String devicesCollection = 'devices';
const String notificationsCollection = 'notifications';

// Firestore fields
const String utcDate = 'utcDate';
const String emptyLeague = '';

// Firebase Messaging topics
const String allDevicesTopic = 'all-devices';
const String wearOSTopic = 'platform-wearos';
const String macOSTopic = 'platform-macos';
const String windowsTopic = 'platform-windows';

// Notification types
const String notificationTypeGoalHome = 'GOAL_HOME';
const String notificationTypeGoalAway = 'GOAL_AWAY';
const String notificationTypeMatchStatus = 'MATCH_STATUS';

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
