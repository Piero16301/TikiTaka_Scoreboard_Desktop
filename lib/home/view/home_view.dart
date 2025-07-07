import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/home/home.dart';
import 'package:tiki_taka_scoreboard_desktop/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_desktop/match/match.dart';
import 'package:tiki_taka_scoreboard_desktop/settings/settings.dart';
import 'package:user_api/user_api.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        context.read<HomeCubit>().reload(value: false);

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          key: state.reload ? UniqueKey() : null,
          stream: context.read<HomeCubit>().getMatches(),
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
                            const SettingsButtonHome(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: [
                                    ScrollText(
                                      text: l10n.titleMatches.toUpperCase(),
                                      style: AppVariables().appTitleFont,
                                    ),
                                    const LastUpdateHome(isLoading: true),
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
                          (index) => const ShimmerMatchCardHome(),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SettingsButtonHome(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  ScrollText(
                                    text: l10n.titleMatches.toUpperCase(),
                                    style: AppVariables().appTitleFont,
                                  ),
                                  const LastUpdateHome(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox.square(dimension: 32),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: ScrollText(text: l10n.errorMatches),
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
                          const SettingsButtonHome(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  ScrollText(
                                    text: l10n.titleMatches.toUpperCase(),
                                    style: AppVariables().appTitleFont,
                                  ),
                                  const LastUpdateHome(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox.square(dimension: 32),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: ScrollText(text: l10n.emptyMatches),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final matches =
                snapshot.data!.docs
                    .map((doc) => Match.fromJson(doc.data()))
                    .toList()
                  ..sort((a, b) {
                    final statusOrder = {
                      'IN_PLAY': 0,
                      'PAUSED': 1,
                      'SCHEDULED': 2,
                      'TIMED': 3,
                    };
                    final aStatus = a.status;
                    final bStatus = b.status;
                    final aOrder = statusOrder[aStatus] ?? 4;
                    final bOrder = statusOrder[bStatus] ?? 4;
                    if (aOrder != bOrder) {
                      return aOrder - bOrder;
                    }
                    return aStatus.compareTo(bStatus);
                  });

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
                          const SettingsButtonHome(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  ScrollText(
                                    text: l10n.titleMatches.toUpperCase(),
                                    style: AppVariables().appTitleFont,
                                  ),
                                  const LastUpdateHome(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox.square(dimension: 32),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...matches.map(
                        (match) => MatchCardHome(match: match),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class LastUpdateHome extends StatefulWidget {
  const LastUpdateHome({
    this.isLoading = false,
    super.key,
  });

  final bool isLoading;

  @override
  State<LastUpdateHome> createState() => _LastUpdateHomeState();
}

class _LastUpdateHomeState extends State<LastUpdateHome>
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
    _nowSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (widget.isLoading) {
      return ScrollText(
        text: l10n.updatingMatches,
      );
    }

    return StreamBuilder(
      stream: context.read<HomeCubit>().getMatchConfigs(),
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

        return ScrollText(
          text: l10n.updatedSecondsAgo(delta.inSeconds),
        );
      },
    );
  }
}

class ShimmerMatchCardHome extends StatelessWidget {
  const ShimmerMatchCardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCardData(
      child: Column(
        children: [
          AppSchimmer(width: 100),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSchimmer(height: 52, width: 52),
                    SizedBox(height: 3),
                    AppSchimmer(width: 40),
                  ],
                ),
              ),
              Expanded(child: AppSchimmer(height: 30)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSchimmer(height: 52, width: 52),
                    SizedBox(height: 3),
                    AppSchimmer(width: 40),
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

class MatchCardHome extends StatelessWidget {
  const MatchCardHome({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = getMatchState(match.status, match.utcDate!, l10n);

    return AppCardButton(
      onPressed: () => Navigator.of(context).pushNamed(
        MatchPage.routeName,
        arguments: match.id,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                CrestImage(crest: match.homeTeam.crest),
                ScrollText(
                  text: match.homeTeam.shortName.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: MatchStatusHome(
              status: match.status,
              state: state,
              match: match,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                CrestImage(crest: match.awayTeam.crest),
                ScrollText(
                  text: match.awayTeam.shortName.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MatchStatusHome extends StatelessWidget {
  const MatchStatusHome({
    required this.status,
    required this.state,
    required this.match,
    super.key,
  });

  final String status;
  final String state;
  final Match match;

  @override
  Widget build(BuildContext context) {
    final darkMode = context.select<AppCubit, bool>(
      (cubit) => cubit.state.darkMode,
    );

    if (status == 'SCHEDULED' || status == 'TIMED') {
      return Column(
        spacing: 10,
        children: [
          CrestImageBackground(
            crest: match.competition.emblem,
            dimension: 30,
          ),
          Text(
            state,
            style: AppVariables().appScoreboardFont,
          ),
        ],
      );
    } else if (status == 'IN_PLAY' || status == 'PAUSED') {
      return Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                match.score.fullTime.home.toString(),
                style: AppVariables().appScoreboardFont,
              ),
              CrestImageBackground(
                crest: match.competition.emblem,
                dimension: 30,
              ),
              Text(
                match.score.fullTime.away.toString(),
                style: AppVariables().appScoreboardFont,
              ),
            ],
          ),
          ScrollText(text: state),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ProgressBar(),
          ),
        ],
      );
    } else {
      return Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                match.score.fullTime.home.toString(),
                style: AppVariables().appScoreboardFont,
              ),
              CrestImageBackground(
                crest: match.competition.emblem,
                dimension: 30,
              ),
              Text(
                match.score.fullTime.away.toString(),
                style: AppVariables().appScoreboardFont,
              ),
            ],
          ),
          ScrollText(text: state),
        ],
      );
    }
  }
}

class SettingsButtonHome extends StatelessWidget {
  const SettingsButtonHome({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final reload =
            (await Navigator.of(context).pushNamed(SettingsPage.routeName))
                as bool? ??
            true;
        if (reload) {
          context.read<HomeCubit>().reload();
        }
      },
      icon: const Icon(FluentIcons.settings, size: 20),
    );
  }
}
