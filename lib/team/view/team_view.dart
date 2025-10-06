import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_desktop/team/team.dart';
import 'package:user_api/user_api.dart';

class TeamView extends StatelessWidget {
  const TeamView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<TeamCubit>().getTeam(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const NavigationView(
            content: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    ShimmerMainInfoTeam(),
                    ShimmerCoachCardTeam(),
                    ShimmerCompetitionsCardTeam(),
                    ShimmerAdditionalInfoTeam(),
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
                  const Row(
                    children: [
                      BackButtonTeam(),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: ScrollText(text: l10n.errorTeam),
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
                  const Row(
                    children: [
                      BackButtonTeam(),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: ScrollText(text: l10n.notFoundTeam),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final team = snapshot.data!.docs
            .map((doc) => Team.fromJson(doc.data()))
            .toList()
            .first;

        return NavigationView(
          content: RippleBackground(
            colors: getTeamColors(team.clubColors),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    MainInfoTeam(team: team),
                    CoachCardTeam(coach: team.coach),
                    if (team.runningCompetitions.isNotEmpty)
                      CompetitionsCardTeam(
                        competitions: team.runningCompetitions,
                      ),
                    AdditionalInfoTeam(team: team),
                    if (team.squad.isNotEmpty)
                      SquadCardTeam(
                        squad: team.squad
                          ..sort(
                            (a, b) =>
                                getStaffPositionOrder(a.position).compareTo(
                                  getStaffPositionOrder(b.position),
                                ),
                          ),
                      ),
                    if (team.staff.isNotEmpty)
                      StaffCardTeam(
                        staff: team.staff
                          ..sort(
                            (a, b) =>
                                getStaffPositionOrder(a.position).compareTo(
                                  getStaffPositionOrder(b.position),
                                ),
                          ),
                      ),
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

class ShimmerMainInfoTeam extends StatelessWidget {
  const ShimmerMainInfoTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButtonTeam(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    AppSchimmer(height: 100, width: 100),
                  ],
                ),
              ),
            ),
            SizedBox.square(dimension: 32),
          ],
        ),
        Column(
          spacing: 10,
          children: [
            AppSchimmer(height: 20, width: 100),
            AppSchimmer(height: 15, width: 50),
          ],
        ),
      ],
    );
  }
}

class MainInfoTeam extends StatelessWidget {
  const MainInfoTeam({
    required this.team,
    super.key,
  });

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButtonTeam(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: CrestImage(crest: team.crest, dimension: 100),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox.square(dimension: 32),
          ],
        ),
        Column(
          spacing: 5,
          children: [
            ScrollText(
              text: team.name.toUpperCase(),
              style: AppVariables().appSettingsFont,
            ),
            ScrollText(
              text: '${team.shortName} (${team.tla})',
              style: AppVariables().appSettingsFont,
            ),
          ],
        ),
      ],
    );
  }
}

class ShimmerCoachCardTeam extends StatelessWidget {
  const ShimmerCoachCardTeam({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 10,
        children: [
          Text(
            l10n.coachTeam.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          Row(
            spacing: 10,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedMentoring,
                color: FluentTheme.of(context).accentColor,
                size: 30,
              ),
              const Expanded(
                child: Column(
                  spacing: 14,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSchimmer(width: 100),
                    AppSchimmer(width: 80),
                    AppSchimmer(width: 60),
                  ],
                ),
              ),
              Column(
                spacing: 10,
                children: [
                  Text(
                    l10n.untilTeam,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const AppSchimmer(width: 50),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CoachCardTeam extends StatelessWidget {
  const CoachCardTeam({
    required this.coach,
    super.key,
  });

  final Staff coach;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 10,
        children: [
          Text(
            l10n.coachTeam.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          Row(
            spacing: 10,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedMentoring,
                color: FluentTheme.of(context).accentColor,
                size: 30,
              ),
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScrollText(
                      text: coach.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      coach.nationality,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.ageTeam(getAge(coach.dateOfBirth)),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    l10n.untilTeam,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    getUntilContract(coach.contract.until),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  int getAge(String dateOfBirth) {
    if (dateOfBirth.isEmpty) return 0;

    final birthDate = DateTime.parse(dateOfBirth);
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String getUntilContract(String until) {
    final dateParts = until.split('-');
    return dateParts.first;
  }
}

class ShimmerCompetitionsCardTeam extends StatelessWidget {
  const ShimmerCompetitionsCardTeam({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        children: [
          Text(
            l10n.competitionsTeam.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          const Row(
            spacing: 10,
            children: [
              AppSchimmer(height: 50, width: 50),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSchimmer(width: 100),
                    AppSchimmer(width: 80),
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

class CompetitionsCardTeam extends StatelessWidget {
  const CompetitionsCardTeam({
    required this.competitions,
    super.key,
  });

  final List<Competition> competitions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 10,
        children: [
          Text(
            l10n.competitionsTeam.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          ...competitions.map(
            (competition) => Row(
              spacing: 10,
              children: [
                CrestImageBackground(
                  crest: competition.emblem,
                  dimension: 40,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollText(
                        text: competition.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        getCompetitionType(
                          competition.type,
                          l10n,
                        ).toUpperCase(),
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

class ShimmerAdditionalInfoTeam extends StatelessWidget {
  const ShimmerAdditionalInfoTeam({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 10,
        children: [
          Text(
            l10n.infoTeam.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedColosseum,
            title: l10n.stadiumTeam,
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedClock02,
            title: l10n.foundationTeam,
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedLocation01,
            title: l10n.addressTeam,
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedInternet,
            title: l10n.websiteTeam,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow({
    required List<List<dynamic>> icon,
    required String title,
    required BuildContext context,
  }) {
    return Row(
      spacing: 10,
      children: [
        HugeIcon(
          icon: icon,
          color: FluentTheme.of(context).accentColor,
          size: 30,
        ),
        Expanded(
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollText(
                text: title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const AppSchimmer(width: 200),
            ],
          ),
        ),
      ],
    );
  }
}

class AdditionalInfoTeam extends StatelessWidget {
  const AdditionalInfoTeam({
    required this.team,
    super.key,
  });

  final Team team;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Column(
        spacing: 10,
        children: [
          Text(
            l10n.infoTeam.toUpperCase(),
            style: AppVariables().appSettingsFont,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedColosseum,
            title: l10n.stadiumTeam,
            value: team.venue,
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedClock02,
            title: l10n.foundationTeam,
            value: team.founded.toString(),
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedLocation01,
            title: l10n.addressTeam,
            value: team.address,
            context: context,
          ),
          buildInfoRow(
            icon: HugeIcons.strokeRoundedInternet,
            title: l10n.websiteTeam,
            value: team.website,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow({
    required List<List<dynamic>> icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      spacing: 10,
      children: [
        HugeIcon(
          icon: icon,
          color: FluentTheme.of(context).accentColor,
          size: 30,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollText(
                text: title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ScrollText(text: value),
            ],
          ),
        ),
      ],
    );
  }
}

class SquadCardTeam extends StatelessWidget {
  const SquadCardTeam({
    required this.squad,
    super.key,
  });

  final List<Staff> squad;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Expander(
        initiallyExpanded: true,
        header: Text(
          l10n.squadTeam.toUpperCase(),
          style: AppVariables().appSettingsFont,
        ),
        content: Column(
          spacing: 10,
          children: squad
              .map(
                (player) => Row(
                  spacing: 10,
                  children: [
                    HugeIcon(
                      icon: getStaffPositionIcon(player.position),
                      color: FluentTheme.of(context).accentColor,
                      size: 30,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScrollText(
                            text: player.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            player.nationality,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.ageTeam(getAge(player.dateOfBirth)),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: getStaffPositionColor(
                          player.position,
                        ).withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        getStaffPosition(player.position, l10n),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  int getAge(String dateOfBirth) {
    if (dateOfBirth.isEmpty) return 0;

    final birthDate = DateTime.parse(dateOfBirth);
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

class StaffCardTeam extends StatelessWidget {
  const StaffCardTeam({
    required this.staff,
    super.key,
  });

  final List<Staff> staff;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCardData(
      child: Expander(
        header: Text(
          l10n.staffTeam.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        content: Column(
          children: staff
              .map(
                (personal) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: getStaffPositionIcon(personal.position),
                        color: FluentTheme.of(context).accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ScrollText(
                              text: personal.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              personal.nationality,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.ageTeam(getAge(personal.dateOfBirth)),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: getStaffPositionColor(personal.position),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          getStaffPosition(personal.position, l10n),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  int getAge(String dateOfBirth) {
    if (dateOfBirth.isEmpty) return 0;

    final birthDate = DateTime.parse(dateOfBirth);
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

class BackButtonTeam extends StatelessWidget {
  const BackButtonTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(FluentIcons.back, size: 20),
    );
  }
}
