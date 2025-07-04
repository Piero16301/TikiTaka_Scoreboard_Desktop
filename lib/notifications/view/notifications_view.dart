import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_desktop/notifications/notifications.dart';
import 'package:tiki_taka_scoreboard_desktop/teams/teams.dart';
import 'package:user_api/user_api.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<NotificationsCubit>().getLeagues(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return NavigationView(
            content: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ScrollText(
                          text: l10n.titleNotifications.toUpperCase(),
                          style: AppVariables().appTitleFont,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        AppVariables.numberOfShimmers,
                        (index) => const ShimmerCardNotifications(),
                      ),
                      const BackButtonNotifications(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return NavigationView(
            content: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.errorNotifications,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return NavigationView(
            content: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.emptyNotifications,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final leagues = snapshot.data!.docs
            .map((doc) => League.fromJson(doc.data()))
            .toList();

        return NavigationView(
          content: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ScrollText(
                        text: l10n.titleNotifications.toUpperCase(),
                        style: AppVariables().appTitleFont,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...leagues.map(
                      (league) => LeagueCardNotifications(league: league),
                    ),
                    const BackButtonNotifications(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerCardNotifications extends StatelessWidget {
  const ShimmerCardNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCardData(
      child: Row(
        children: [
          SizedBox(width: 10),
          AppSchimmer(height: 40, width: 40),
          SizedBox(width: 10),
          Expanded(child: AppSchimmer()),
          SizedBox(width: 10),
          SizedBox.square(
            dimension: 40,
            child: IconButton(
              onPressed: null,
              icon: Icon(FluentIcons.forward),
            ),
          ),
        ],
      ),
    );
  }
}

class LeagueCardNotifications extends StatelessWidget {
  const LeagueCardNotifications({
    required this.league,
    super.key,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: Row(
        children: [
          CrestImage(crest: league.emblem),
          const SizedBox(width: 5),
          Expanded(child: ScrollText(text: league.name)),
          const SizedBox(width: 5),
          SizedBox.square(
            dimension: 40,
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                TeamsPage.routeName,
                arguments: league.id,
              ),
              icon: const Icon(FluentIcons.forward),
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonNotifications extends StatelessWidget {
  const BackButtonNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: FilledButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                l10n.backText.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
