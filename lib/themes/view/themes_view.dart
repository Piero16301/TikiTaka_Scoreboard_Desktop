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
                    text: l10n.titleTheme.toUpperCase(),
                    style: AppVariables().appTitleFont,
                  ),
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

class CardThemes extends StatelessWidget {
  const CardThemes({
    required this.isDark,
    required this.text,
    required this.icon,
    super.key,
  });

  final bool isDark;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: Row(
        children: [
          BlocBuilder<AppCubit, AppState>(
            builder: (context, state) => RadioButton(
              checked: state.darkMode == isDark,
              onChanged: (checked) {
                if (checked) {
                  context.read<AppCubit>().changeTheme(darkMode: isDark);
                }
              },
            ),
          ),
          HugeIcon(
            icon: icon,
            color: FluentTheme.of(context).accentColor,
          ),
          const SizedBox(width: 10),
          Expanded(child: ScrollText(text: text)),
        ],
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
