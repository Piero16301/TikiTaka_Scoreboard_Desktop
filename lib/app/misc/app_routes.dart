import 'package:fluent_ui/fluent_ui.dart';
import 'package:tiki_taka_scoreboard_desktop/home/home.dart';
import 'package:tiki_taka_scoreboard_desktop/languages/languages.dart';
import 'package:tiki_taka_scoreboard_desktop/leagues/leagues.dart';
import 'package:tiki_taka_scoreboard_desktop/match/match.dart';
import 'package:tiki_taka_scoreboard_desktop/notifications/notifications.dart';
import 'package:tiki_taka_scoreboard_desktop/settings/settings.dart';
import 'package:tiki_taka_scoreboard_desktop/team/team.dart';
import 'package:tiki_taka_scoreboard_desktop/teams/teams.dart';
import 'package:tiki_taka_scoreboard_desktop/themes/themes.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomePage.routeName: (_) => const HomePage(),
    MatchPage.routeName: (context) => MatchPage(
      matchId: ModalRoute.of(context)!.settings.arguments as int? ?? 0,
    ),
    TeamPage.routeName: (context) => TeamPage(
      teamId: ModalRoute.of(context)!.settings.arguments as int? ?? 0,
    ),
    SettingsPage.routeName: (_) => const SettingsPage(),
    LeaguesPage.routeName: (_) => const LeaguesPage(),
    LanguagesPage.routeName: (_) => const LanguagesPage(),
    ThemesPage.routeName: (_) => const ThemesPage(),
    NotificationsPage.routeName: (_) => const NotificationsPage(),
    TeamsPage.routeName: (context) => TeamsPage(
      leagueId: ModalRoute.of(context)!.settings.arguments as int? ?? 0,
    ),
  };
}
