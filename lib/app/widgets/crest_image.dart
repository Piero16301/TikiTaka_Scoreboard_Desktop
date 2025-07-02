import 'package:fluent_ui/fluent_ui.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CrestImage extends StatelessWidget {
  const CrestImage({
    required this.crest,
    this.dimension = 40,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String crest;
  final double dimension;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (crest.contains('.svg')) {
      return SizedBox(
        height: dimension,
        width: dimension,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: VectorGraphic(
            loader: NetworkSvgLoader(crest),
            fit: fit,
            errorBuilder: (context, error, stackTrace) => Icon(
              FluentIcons.picture,
              size: dimension,
            ),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          crest,
          width: dimension,
          height: dimension,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => Icon(
            FluentIcons.picture,
            size: dimension,
          ),
        ),
      );
    }
  }
}
