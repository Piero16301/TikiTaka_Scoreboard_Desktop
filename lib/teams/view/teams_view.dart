import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_desktop/teams/teams.dart';
import 'package:user_api/user_api.dart';

class TeamsView extends StatelessWidget {
  const TeamsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<TeamsCubit>().getTeams(),
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
                        const BackButtonTeams(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                ScrollText(
                                  text: l10n.titleTeams.toUpperCase(),
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
                      (index) => const ShimmerCardTeams(),
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
                      const BackButtonTeams(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleTeams.toUpperCase(),
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
                      child: ScrollText(text: l10n.errorTeams),
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
                      const BackButtonTeams(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleTeams.toUpperCase(),
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
                      child: ScrollText(text: l10n.emptyTeams),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final teams = snapshot.data!.docs
            .map((doc) => Team.fromJson(doc.data()))
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
                      const BackButtonTeams(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ScrollText(
                                text: l10n.titleTeams.toUpperCase(),
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
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: context.read<TeamsCubit>().getDevices(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      if (snapshot.hasError) {
                        return const SizedBox.shrink();
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final enabledTeams =
                          snapshot.data!.docs.first.data()['enabledTeams']
                              as List<dynamic>? ??
                          [];

                      return Column(
                        children: teams
                            .map(
                              (team) => TeamCardTeams(
                                enabledTeams: enabledTeams
                                    .map((e) => e.toString())
                                    .toList(),
                                team: team,
                              ),
                            )
                            .toList(),
                      );
                    },
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

class ShimmerCardTeams extends StatelessWidget {
  const ShimmerCardTeams({super.key});

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

class TeamCardTeams extends StatelessWidget {
  const TeamCardTeams({
    required this.enabledTeams,
    required this.team,
    super.key,
  });

  final List<String> enabledTeams;
  final Team team;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsCubit, TeamsState>(
      builder: (context, state) {
        final enabled = enabledTeams.contains(team.id.toString());
        return AppCardButton(
          onPressed: () => context.read<TeamsCubit>().toggleTeam(
            team: team,
            enabledTeams: enabledTeams,
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
                      context.read<TeamsCubit>().toggleTeam(
                        team: team,
                        enabledTeams: enabledTeams,
                      );
                    },
                  ),
                ),
              ),
              CrestImageBackground(
                crest: team.crest,
                dimension: 50,
              ),
              Expanded(
                child: ScrollText(
                  text: team.name.toUpperCase(),
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

class BackButtonTeams extends StatelessWidget {
  const BackButtonTeams({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(FluentIcons.back, size: 20),
    );
  }
}
