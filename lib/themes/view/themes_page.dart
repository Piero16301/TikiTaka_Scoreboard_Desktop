import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_desktop/themes/themes.dart';

class ThemesPage extends StatelessWidget {
  const ThemesPage({super.key});

  static const String routeName = '/themes';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemesCubit(),
      child: const ThemesView(),
    );
  }
}
