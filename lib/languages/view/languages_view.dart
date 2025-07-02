import 'package:dash_flags/dash_flags.dart';
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
                    text: l10n.titleLanguage.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),
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
                const BackButtonLanguages(),
                const SizedBox(height: 50),
              ],
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 50,
        child: Card(
          child: Stack(
            children: [
              Opacity(
                opacity: 0.1,
                child: CountryFlag(
                  country: Country.fromCode(flag),
                  height: double.infinity,
                ),
              ),
              Row(
                children: [
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) => RadioButton(
                      checked: state.language == value,
                      onChanged: (checked) {
                        if (checked) {
                          context.read<AppCubit>().changeLanguage(value);
                        }
                      },
                    ),
                  ),
                  Expanded(child: ScrollText(text: language)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackButtonLanguages extends StatelessWidget {
  const BackButtonLanguages({super.key});

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
