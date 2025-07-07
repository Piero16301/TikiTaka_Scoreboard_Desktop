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
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const BackButtonNotifications(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                ScrollText(
                                  text: l10n.titleNotifications.toUpperCase(),
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
                    ...List.generate(
                      AppVariables.numberOfShimmers,
                      (index) => const ShimmerCardNotifications(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return NavigationView(
            content: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const BackButtonNotifications(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleNotifications.toUpperCase(),
                                style: AppVariables().appTitleFont,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox.square(dimension: 32),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: ScrollText(text: l10n.errorNotifications),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return NavigationView(
            content: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const BackButtonNotifications(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleNotifications.toUpperCase(),
                                style: AppVariables().appTitleFont,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox.square(dimension: 32),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: ScrollText(text: l10n.emptyNotifications),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final leagues = snapshot.data!.docs
            .map((doc) => League.fromJson(doc.data()))
            .toList();

        return NavigationView(
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const BackButtonNotifications(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleNotifications.toUpperCase(),
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
                  ...leagues.map(
                    (league) => LeagueCardNotifications(league: league),
                  ),
                ],
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
          AppSchimmer(height: 52, width: 52),
          SizedBox(width: 10),
          Expanded(child: AppSchimmer()),
          SizedBox(width: 10),
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
    final darkMode = context.select<AppCubit, bool>(
      (cubit) => cubit.state.darkMode,
    );

    return AppCardButton(
      onPressed: () => Navigator.of(context).pushNamed(
        TeamsPage.routeName,
        arguments: league.id,
      ),
      child: Row(
        spacing: 10,
        children: [
          CrestImageBackground(
            crest: league.emblem,
            dimension: 50,
          ),
          Expanded(
            child: ScrollText(
              text: league.name.toUpperCase(),
              style: AppVariables().appSettingsFont,
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
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(FluentIcons.back, size: 20),
    );
  }
}
