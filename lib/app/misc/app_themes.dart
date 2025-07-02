import 'package:fluent_ui/fluent_ui.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';

class AppThemes {
  static final darkTheme = FluentThemeData(
    fontFamily: appFont.fontFamily,
    visualDensity: VisualDensity.compact,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    cardColor: const Color.fromRGBO(50, 49, 47, 1),
    buttonTheme: ButtonThemeData(
      filledButtonStyle: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ),
  );

  static final lightTheme = FluentThemeData(
    fontFamily: appFont.fontFamily,
    visualDensity: VisualDensity.compact,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    cardColor: const Color.fromARGB(255, 207, 207, 207),
    buttonTheme: ButtonThemeData(
      filledButtonStyle: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ),
  );
}
