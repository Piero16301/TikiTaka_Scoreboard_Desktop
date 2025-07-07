import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_desktop/leagues/leagues.dart';
import 'package:user_api/user_api.dart';

class LeaguesView extends StatelessWidget {
  const LeaguesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<LeaguesCubit>().getLeagues(),
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
                        const BackButtonCompetitions(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                ScrollText(
                                  text: l10n.titleLeagues.toUpperCase(),
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
                      (index) => const ShimmerCardLeagues(),
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
                      const BackButtonCompetitions(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleLeagues.toUpperCase(),
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
                      child: ScrollText(text: l10n.errorLeagues),
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
                      const BackButtonCompetitions(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleLeagues.toUpperCase(),
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
                      child: ScrollText(text: l10n.emptyLeagues),
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
                      const BackButtonCompetitions(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleLeagues.toUpperCase(),
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
                    (league) => LeagueCardCompetitions(league: league),
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

class ShimmerCardLeagues extends StatelessWidget {
  const ShimmerCardLeagues({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCardData(
      child: Row(
        spacing: 10,
        children: [
          SizedBox(
            width: 40,
            child: FittedBox(
              fit: BoxFit.fill,
              child: ToggleSwitch(
                checked: false,
                onChanged: null,
              ),
            ),
          ),
          AppSchimmer(height: 52, width: 52),
          Expanded(child: AppSchimmer()),
        ],
      ),
    );
  }
}

class LeagueCardCompetitions extends StatelessWidget {
  const LeagueCardCompetitions({
    required this.league,
    super.key,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    final darkMode = context.select<AppCubit, bool>(
      (cubit) => cubit.state.darkMode,
    );

    return BlocBuilder<LeaguesCubit, LeaguesState>(
      builder: (context, state) {
        final enabled = state.enabledLeagues[league.code] ?? false;
        return AppCardButton(
          onPressed: () => context.read<LeaguesCubit>().toggleLeague(
            league: league.code,
            enabled: !enabled,
          ),
          child: Row(
            spacing: 10,
            children: [
              SizedBox(
                width: 40,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: ToggleSwitch(
                    checked: enabled,
                    onChanged: (value) {
                      context.read<LeaguesCubit>().toggleLeague(
                        league: league.code,
                        enabled: value,
                      );
                    },
                  ),
                ),
              ),
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
      },
    );
  }
}

class BackButtonCompetitions extends StatelessWidget {
  const BackButtonCompetitions({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(FluentIcons.back, size: 20),
    );
  }
}
