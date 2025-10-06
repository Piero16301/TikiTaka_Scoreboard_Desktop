import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Table;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_desktop/match/match.dart';
import 'package:tiki_taka_scoreboard_desktop/team/team.dart';
import 'package:user_api/user_api.dart';

class MatchView extends StatelessWidget {
  const MatchView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<MatchCubit>().getMatch(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackButtonMatch(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                ScrollText(
                                  text: l10n.titleMatch.toUpperCase(),
                                  style: AppVariables().appTitleFont,
                                ),
                                const LastUpdateMatch(isLoading: true),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox.square(dimension: 32),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const ShimmerTeamsCardMatch(),
                    const ShimmerRefereeCardMatch(),
                    const ShimmerCompetitionCardMatch(),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BackButtonMatch(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleMatch.toUpperCase(),
                                style: AppVariables().appTitleFont,
                              ),
                              const LastUpdateMatch(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox.square(dimension: 32),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: ScrollText(text: l10n.errorMatch),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BackButtonMatch(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleMatch.toUpperCase(),
                                style: AppVariables().appTitleFont,
                              ),
                              const LastUpdateMatch(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox.square(dimension: 32),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: ScrollText(text: l10n.notFoundMatch),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final match = snapshot.data!.docs
            .map((doc) => Match.fromJson(doc.data()))
            .toList()
            .first;

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BackButtonMatch(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleMatch.toUpperCase(),
                                style: AppVariables().appTitleFont,
                              ),
                              const LastUpdateMatch(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox.square(dimension: 32),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TeamsCardMatch(match: match),
                  if (match.referees.isNotEmpty)
                    RefereeCardMatch(referees: match.referees),
                  CompetitionCardMatch(match: match),
                  StandingsMatch(match: match),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LastUpdateMatch extends StatefulWidget {
  const LastUpdateMatch({
    this.isLoading = false,
    super.key,
  });

  final bool isLoading;

  @override
  State<LastUpdateMatch> createState() => _LastUpdateMatchState();
}

class _LastUpdateMatchState extends State<LastUpdateMatch>
    with WidgetsBindingObserver {
  late StreamSubscription<void> _nowSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _nowSubscription = Stream<void>.periodic(
      const Duration(seconds: 1),
    ).listen((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_nowSubscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (widget.isLoading) {
      return Text(
        l10n.updatingMatches,
      );
    }

    return StreamBuilder(
      stream: context.read<MatchCubit>().getMatchConfigs(),
      builder: (context, snapshot) {
        final configs =
            snapshot.data?.docs
                .map((doc) => Config.fromJson(doc.data()))
                .toList() ??
            [
              Config(
                id: AppVariables.matchesCollection,
                lastUpdate: DateTime.now(),
              ),
            ];

        if (configs.isEmpty) {
          configs.add(
            Config(
              id: AppVariables.matchesCollection,
              lastUpdate: DateTime.now(),
            ),
          );
        }

        final delta = DateTime.now().difference(configs.first.lastUpdate);

        return Text(
          l10n.updatedSecondsAgo(delta.inSeconds),
        );
      },
    );
  }
}

class ShimmerTeamsCardMatch extends StatelessWidget {
  const ShimmerTeamsCardMatch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 11,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              PointTextMatch(value: l10n.halfTimeAbbr),
              PointTextMatch(value: l10n.fullTimeAbbr),
            ],
          ),
          const Row(
            spacing: 10,
            children: [
              AppSchimmer(height: 85, width: 85),
              Expanded(child: AppSchimmer()),
              SizedBox(
                width: 30,
                child: AppSchimmer(width: 30),
              ),
              SizedBox(
                width: 30,
                child: AppSchimmer(width: 30),
              ),
            ],
          ),
          const Row(
            spacing: 10,
            children: [
              AppSchimmer(height: 85, width: 85),
              Expanded(child: AppSchimmer()),
              SizedBox(
                width: 30,
                child: AppSchimmer(width: 30),
              ),
              SizedBox(
                width: 30,
                child: AppSchimmer(width: 30),
              ),
            ],
          ),
          const AppSchimmer(width: 100),
        ],
      ),
    );
  }
}

class TeamsCardMatch extends StatelessWidget {
  const TeamsCardMatch({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              PointTextMatch(value: l10n.halfTimeAbbr),
              PointTextMatch(value: l10n.fullTimeAbbr),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              AppCardButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  TeamPage.routeName,
                  arguments: match.homeTeam.id,
                ),
                child: CrestImage(crest: match.homeTeam.crest),
              ),
              Expanded(
                child: ScrollText(
                  text: match.homeTeam.name.toUpperCase(),
                  style: AppVariables().appSettingsFont,
                ),
              ),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    match.score.halfTime.home.toString(),
                    style: AppVariables().appScoreboardFont.copyWith(
                      fontSize: AppVariables.matchSmallStatusSize,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    match.score.fullTime.home.toString(),
                    style: AppVariables().appScoreboardFont,
                  ),
                ),
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              AppCardButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  TeamPage.routeName,
                  arguments: match.awayTeam.id,
                ),
                child: CrestImage(crest: match.awayTeam.crest),
              ),
              Expanded(
                child: ScrollText(
                  text: match.awayTeam.name.toUpperCase(),
                  style: AppVariables().appSettingsFont,
                ),
              ),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    match.score.halfTime.away.toString(),
                    style: AppVariables().appScoreboardFont.copyWith(
                      fontSize: AppVariables.matchSmallStatusSize,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    match.score.fullTime.away.toString(),
                    style: AppVariables().appScoreboardFont,
                  ),
                ),
              ),
            ],
          ),
          Text(
            getMatchState(match.status, match.utcDate!, l10n),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ShimmerRefereeCardMatch extends StatelessWidget {
  const ShimmerRefereeCardMatch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 10,
        children: [
          Text(
            l10n.refereesMatch.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          Row(
            spacing: 10,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedWhistle,
                color: FluentTheme.of(context).accentColor,
                size: 30,
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 13,
                  children: [
                    AppSchimmer(height: 14),
                    AppSchimmer(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RefereeCardMatch extends StatelessWidget {
  const RefereeCardMatch({
    required this.referees,
    super.key,
  });

  final List<Referee> referees;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 10,
        children: [
          Text(
            l10n.refereesMatch.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          ...referees.map(
            (referee) => Row(
              spacing: 10,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedWhistle,
                  color: FluentTheme.of(context).accentColor,
                  size: 30,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      ScrollText(
                        text: referee.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        referee.nationality,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerCompetitionCardMatch extends StatelessWidget {
  const ShimmerCompetitionCardMatch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 10,
        children: [
          Text(
            l10n.competitionsMatch.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          const Row(
            spacing: 10,
            children: [
              AppSchimmer(height: 58, width: 58),
              Expanded(child: AppSchimmer()),
            ],
          ),
          const Row(
            spacing: 10,
            children: [
              AppSchimmer(height: 58, width: 58),
              Expanded(child: AppSchimmer()),
            ],
          ),
          const AppSchimmer(width: 200),
          const AppSchimmer(width: 100),
        ],
      ),
    );
  }
}

class CompetitionCardMatch extends StatelessWidget {
  const CompetitionCardMatch({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 10,
        children: [
          Text(
            l10n.competitionsMatch.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          Row(
            spacing: 10,
            children: [
              CrestImageBackground(
                crest: match.area.flag,
                dimension: 40,
              ),
              Expanded(
                child: ScrollText(
                  text: match.area.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              CrestImageBackground(
                crest: match.competition.emblem,
                dimension: 40,
              ),
              Expanded(
                child: ScrollText(
                  text: match.competition.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${l10n.seasonMatch} ${match.season.startDate!.year}'
                    '-${match.season.endDate!.year}'
                .toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${l10n.matchdayMatch} ${match.matchday}'.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StandingsMatch extends StatelessWidget {
  const StandingsMatch({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<MatchCubit>().getStandings(
        leagueId: match.competition.id.toString(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AppCardData(
            child: Column(
              spacing: 20,
              children: [
                Text(
                  l10n.standingsMatch.toUpperCase(),
                  style: AppVariables().appSettingsFont,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 10,
                      children: [
                        PointTextMatch(value: l10n.playedGamesAbbr),
                        PointTextMatch(value: l10n.winnedGamesAbbr),
                        PointTextMatch(value: l10n.drawnGamesAbbr),
                        PointTextMatch(value: l10n.lostGamesAbbr),
                        PointTextMatch(value: l10n.goalsForAbbr),
                        PointTextMatch(value: l10n.goalsAgainstAbbr),
                        PointTextMatch(value: l10n.goalDifferenceAbbr),
                        PointTextMatch(value: l10n.pointsAbbr),
                      ],
                    ),
                    ...List.generate(
                      AppVariables.numberOfShimmers * 2,
                      (index) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            PointTextMatch(value: (index + 1).toString()),
                            const AppSchimmer(height: 42, width: 42),
                            const Expanded(child: AppSchimmer()),
                            const SizedBox(
                              width: 30,
                              child: AppSchimmer(width: 30),
                            ),
                            const SizedBox(
                              width: 30,
                              child: AppSchimmer(width: 30),
                            ),
                            const SizedBox(
                              width: 30,
                              child: AppSchimmer(width: 30),
                            ),
                            const SizedBox(
                              width: 30,
                              child: AppSchimmer(width: 30),
                            ),
                            const SizedBox(
                              width: 30,
                              child: AppSchimmer(width: 30),
                            ),
                            const SizedBox(
                              width: 30,
                              child: AppSchimmer(width: 30),
                            ),
                            const SizedBox(
                              width: 30,
                              child: AppSchimmer(width: 30),
                            ),
                            const SizedBox(
                              width: 30,
                              child: AppSchimmer(width: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        if (snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final result = snapshot.data!.docs.map((doc) => doc.data()).toList();
        if (result.isEmpty || result.length > 1) {
          return const SizedBox.shrink();
        }

        final standingsList =
            result.first[AppVariables.standingsCollection] as List<dynamic>? ??
            [];

        if (standingsList.isEmpty) {
          return const SizedBox.shrink();
        }

        final standings = standingsList
            .map(
              (standing) =>
                  Standing.fromJson(standing as Map<String, dynamic>? ?? {}),
            )
            .toList();

        if (standings.length == 1) {
          return AppCardData(
            child: Column(
              spacing: 20,
              children: [
                Text(
                  l10n.standingsMatch.toUpperCase(),
                  style: AppVariables().appSettingsFont,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 10,
                      children: [
                        PointTextMatch(value: l10n.playedGamesAbbr),
                        PointTextMatch(value: l10n.winnedGamesAbbr),
                        PointTextMatch(value: l10n.drawnGamesAbbr),
                        PointTextMatch(value: l10n.lostGamesAbbr),
                        PointTextMatch(value: l10n.goalsForAbbr),
                        PointTextMatch(value: l10n.goalsAgainstAbbr),
                        PointTextMatch(value: l10n.goalDifferenceAbbr),
                        PointTextMatch(value: l10n.pointsAbbr),
                      ],
                    ),
                    ...standings.first.table.map(
                      (row) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: getRowStandingColor(row, match),
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            PointTextMatch(value: row.position.toString()),
                            AppCardButton(
                              onPressed: () => Navigator.of(context).pushNamed(
                                TeamPage.routeName,
                                arguments: row.team.id,
                              ),
                              child: CrestImage(
                                crest: row.team.crest,
                                dimension: 25,
                              ),
                            ),
                            Expanded(
                              child: ScrollText(
                                text: row.team.shortName.toUpperCase(),
                              ),
                            ),
                            PointTextMatch(
                              value: '${row.playedGames}',
                            ),
                            PointTextMatch(
                              value: '${row.won}',
                            ),
                            PointTextMatch(
                              value: '${row.draw}',
                            ),
                            PointTextMatch(
                              value: '${row.lost}',
                            ),
                            PointTextMatch(
                              value: '${row.goalsFor}',
                            ),
                            PointTextMatch(
                              value: '${row.goalsAgainst}',
                            ),
                            PointTextMatch(
                              value: '${row.goalDifference}',
                            ),
                            PointTextMatch(
                              value: '${row.points}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: standings
                .map(
                  (standing) => AppCardData(
                    child: Column(
                      spacing: 20,
                      children: [
                        Text(
                          standing.group.toUpperCase(),
                          style: AppVariables().appSettingsFont,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              spacing: 10,
                              children: [
                                PointTextMatch(value: l10n.playedGamesAbbr),
                                PointTextMatch(value: l10n.winnedGamesAbbr),
                                PointTextMatch(value: l10n.drawnGamesAbbr),
                                PointTextMatch(value: l10n.lostGamesAbbr),
                                PointTextMatch(value: l10n.goalsForAbbr),
                                PointTextMatch(value: l10n.goalsAgainstAbbr),
                                PointTextMatch(value: l10n.goalDifferenceAbbr),
                                PointTextMatch(value: l10n.pointsAbbr),
                              ],
                            ),
                            ...standing.table.map(
                              (row) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: getRowStandingColor(row, match),
                                ),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    PointTextMatch(
                                      value: row.position.toString(),
                                    ),
                                    AppCardButton(
                                      onPressed: () =>
                                          Navigator.of(context).pushNamed(
                                            TeamPage.routeName,
                                            arguments: row.team.id,
                                          ),
                                      child: CrestImage(
                                        crest: row.team.crest,
                                        dimension: 25,
                                      ),
                                    ),
                                    Expanded(
                                      child: ScrollText(
                                        text: row.team.shortName.toUpperCase(),
                                      ),
                                    ),
                                    PointTextMatch(
                                      value: '${row.playedGames}',
                                    ),
                                    PointTextMatch(
                                      value: '${row.won}',
                                    ),
                                    PointTextMatch(
                                      value: '${row.draw}',
                                    ),
                                    PointTextMatch(
                                      value: '${row.lost}',
                                    ),
                                    PointTextMatch(
                                      value: '${row.goalsFor}',
                                    ),
                                    PointTextMatch(
                                      value: '${row.goalsAgainst}',
                                    ),
                                    PointTextMatch(
                                      value: '${row.goalDifference}',
                                    ),
                                    PointTextMatch(
                                      value: '${row.points}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Color? getRowStandingColor(Table row, Match match) {
    if (row.team.id == match.homeTeam.id) {
      return Colors.blue.withValues(alpha: 0.2);
    } else if (row.team.id == match.awayTeam.id) {
      return Colors.red.withValues(alpha: 0.2);
    }
    return null;
  }
}

class PointTextMatch extends StatelessWidget {
  const PointTextMatch({
    required this.value,
    super.key,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: AppVariables.markerTitleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class BackButtonMatch extends StatelessWidget {
  const BackButtonMatch({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(FluentIcons.back, size: 20),
    );
  }
}
