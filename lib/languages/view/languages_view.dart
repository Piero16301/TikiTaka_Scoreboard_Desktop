import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/l10n/l10n.dart';

class LanguagesView extends StatelessWidget {
  const LanguagesView({super.key});

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
                  const BackButtonLanguages(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ScrollText(
                            text: l10n.titleLanguage.toUpperCase(),
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
              CardLanguages(
                value: 'en_US',
                flag: l10n.englishFlag,
                language: l10n.englishLanguage,
              ),
              CardLanguages(
                value: 'es_ES',
                flag: l10n.spanishFlag,
                language: l10n.spanishLanguage,
              ),
              CardLanguages(
                value: 'it_IT',
                flag: l10n.italianFlag,
                language: l10n.italianLanguage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardLanguages extends StatelessWidget {
  const CardLanguages({
    required this.value,
    required this.flag,
    required this.language,
    super.key,
  });

  final String value;
  final String flag;
  final String language;

  @override
  Widget build(BuildContext context) {
    return AppCardButton(
      onPressed: () => context.read<AppCubit>().changeLanguage(value),
      child: Row(
        spacing: 20,
        children: [
          BlocBuilder<AppCubit, AppState>(
            builder: (context, state) => RadioButton(
              checked: state.language == value,
              onChanged: (checked) {
                if (checked) {
                  unawaited(context.read<AppCubit>().changeLanguage(value));
                }
              },
            ),
          ),
          Expanded(
            child: ScrollText(
              text: language.toUpperCase(),
              style: AppVariables().appSettingsFont,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonLanguages extends StatelessWidget {
  const BackButtonLanguages({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(FluentIcons.back, size: 20),
    );
  }
}
