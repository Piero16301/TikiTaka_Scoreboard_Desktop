import 'package:fluent_ui/fluent_ui.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';

class AppThemes {
  static final darkTheme = FluentThemeData(
    fontFamily: AppVariables().appGlobalFont.fontFamily,
    visualDensity: VisualDensity.compact,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    cardColor: const Color.fromRGBO(50, 49, 47, 1),
  );

  static final lightTheme = FluentThemeData(
    fontFamily: AppVariables().appGlobalFont.fontFamily,
    visualDensity: VisualDensity.compact,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    cardColor: const Color.fromARGB(255, 207, 207, 207),
  );
}
