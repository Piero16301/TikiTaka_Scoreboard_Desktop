import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/l10n/l10n.dart';

class ThemesView extends StatelessWidget {
  const ThemesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                  const BackButtonThemes(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ScrollText(
                            text: l10n.titleTheme.toUpperCase(),
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
              CardThemes(
                isDark: false,
                text: l10n.lightTheme,
                icon: HugeIcons.strokeRoundedSun01,
              ),
              CardThemes(
                isDark: true,
                text: l10n.darkTheme,
                icon: HugeIcons.strokeRoundedMoon02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardThemes extends StatelessWidget {
  const CardThemes({
    required this.isDark,
    required this.text,
    required this.icon,
    super.key,
  });

  final bool isDark;
  final String text;
  final List<List<dynamic>> icon;

  @override
  Widget build(BuildContext context) {
    return AppCardButton(
      onPressed: () => context.read<AppCubit>().changeTheme(darkMode: isDark),
      child: Row(
        spacing: 20,
        children: [
          BlocBuilder<AppCubit, AppState>(
            builder: (context, state) => RadioButton(
              checked: state.darkMode == isDark,
              onChanged: (checked) {
                if (checked) {
                  unawaited(
                    context.read<AppCubit>().changeTheme(darkMode: isDark),
                  );
                }
              },
            ),
          ),
          HugeIcon(
            icon: icon,
            color: FluentTheme.of(context).accentColor,
          ),
          Expanded(
            child: ScrollText(
              text: text.toUpperCase(),
              style: AppVariables().appSettingsFont,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonThemes extends StatelessWidget {
  const BackButtonThemes({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(FluentIcons.back, size: 20),
    );
  }
}
