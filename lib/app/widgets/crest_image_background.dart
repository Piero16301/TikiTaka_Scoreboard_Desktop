import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';

class CrestImageBackground extends StatelessWidget {
  const CrestImageBackground({
    required this.crest,
    this.dimension = 60,
    this.fit = BoxFit.fill,
    this.visible = true,
    super.key,
  });

  final String crest;
  final double dimension;
  final BoxFit fit;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final darkMode = context.select<AppCubit, bool>(
      (cubit) => cubit.state.darkMode,
    );

    return Visibility(
      visible: visible,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: darkMode
              ? Colors.white.withValues(alpha: 0.8)
              : Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: CrestImage(
          crest: crest,
          dimension: dimension,
          fit: fit,
        ),
      ),
    );
  }
}
