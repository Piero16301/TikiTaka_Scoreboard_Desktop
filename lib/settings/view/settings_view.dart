import 'package:fluent_ui/fluent_ui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_desktop/languages/languages.dart';
import 'package:tiki_taka_scoreboard_desktop/leagues/leagues.dart';
import 'package:tiki_taka_scoreboard_desktop/notifications/notifications.dart';
import 'package:tiki_taka_scoreboard_desktop/themes/themes.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return NavigationView(
      content: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const BackButtonSettings(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ScrollText(
                            text: l10n.titleSettings.toUpperCase(),
                            style: AppVariables().appTitleFont,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox.square(dimension: 32),
                ],
              ),
              const SizedBox(height: 10),
              ConfigurationSetting(
                title: l10n.titleLeagues.toUpperCase(),
                icon: HugeIcons.strokeRoundedFootball,
                route: LeaguesPage.routeName,
              ),
              ConfigurationSetting(
                title: l10n.titleNotifications.toUpperCase(),
                icon: HugeIcons.strokeRoundedNotification01,
                route: NotificationsPage.routeName,
              ),
              ConfigurationSetting(
                title: l10n.titleLanguage.toUpperCase(),
                icon: HugeIcons.strokeRoundedLanguageSkill,
                route: LanguagesPage.routeName,
              ),
              ConfigurationSetting(
                title: l10n.titleTheme.toUpperCase(),
                icon: HugeIcons.strokeRoundedPaintBoard,
                route: ThemesPage.routeName,
              ),
              const AppInfoSettings(),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfigurationSetting extends StatelessWidget {
  const ConfigurationSetting({
    required this.title,
    required this.icon,
    required this.route,
    super.key,
  });

  final String title;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return AppCardButton(
      onPressed: () => Navigator.of(context).pushNamed(route),
      child: Row(
        spacing: 10,
        children: [
          HugeIcon(
            icon: icon,
            size: 30,
            color: FluentTheme.of(context).accentColor,
          ),
          Expanded(
            child: ScrollText(
              text: title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonSettings extends StatelessWidget {
  const BackButtonSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(FluentIcons.back, size: 20),
    );
  }
}

class AppInfoSettings extends StatelessWidget {
  const AppInfoSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final packageInfo = LocalSettingsService.instance.packageInfo;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Text(
            packageInfo.appName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'Version: ${packageInfo.version} (${packageInfo.buildNumber})',
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          Text(
            '${l10n.updatedOn}: ${getDateOn(l10n, packageInfo.updateTime)}',
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String getDateOn(AppLocalizations l10n, DateTime? date) {
    if (date == null) {
      return l10n.todayText;
    }

    final now = DateTime.now().toLocal();

    // Check if the date is today
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return DateFormat('HH:mm:ss').format(date);
    }
    // Otherwise return date as dd-MM-yyyy
    else {
      return DateFormat('dd-MM-yyyy').format(date);
    }
  }
}
