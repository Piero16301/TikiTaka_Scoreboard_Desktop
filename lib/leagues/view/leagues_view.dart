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
                          text: l10n.titleLeagues.toUpperCase(),
                          style: AppVariables().appTitleFont,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        AppVariables.numberOfShimmers,
                        (index) => const ShimmerCardLeagues(),
                      ),
                      const BackButtonCompetitions(),
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
                        l10n.errorLeagues,
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
                        l10n.emptyLeagues,
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
                        text: l10n.titleLeagues.toUpperCase(),
                        style: AppVariables().appTitleFont,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...leagues.map(
                      (league) => LeagueCardCompetitions(league: league),
                    ),
                    const BackButtonCompetitions(),
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

class ShimmerCardLeagues extends StatelessWidget {
  const ShimmerCardLeagues({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCardData(
      child: Row(
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
          SizedBox(width: 5),
          AppSchimmer(height: 40, width: 40),
          SizedBox(width: 5),
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
    return AppCardData(
      child: Row(
        children: [
          BlocBuilder<LeaguesCubit, LeaguesState>(
            builder: (context, state) {
              final enabled = state.enabledLeagues[league.code] ?? false;
              return SizedBox(
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
              );
            },
          ),
          const SizedBox(width: 5),
          CrestImage(crest: league.emblem),
          const SizedBox(width: 5),
          Expanded(child: ScrollText(text: league.name)),
        ],
      ),
    );
  }
}

class BackButtonCompetitions extends StatelessWidget {
  const BackButtonCompetitions({super.key});

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
