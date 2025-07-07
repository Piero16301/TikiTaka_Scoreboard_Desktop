import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';

class CrestImage extends StatefulWidget {
  const CrestImage({
    required this.crest,
    this.dimension = 60,
    this.fit = BoxFit.fill,
    super.key,
  });

  final String crest;
  final double dimension;
  final BoxFit fit;

  @override
  State<CrestImage> createState() => _CrestImageState();
}

class _CrestImageState extends State<CrestImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.crest.contains('.svg')) {
      return SizedBox.square(
        dimension: widget.dimension,
        child: SvgPicture.network(
          widget.crest,
          width: widget.dimension,
          height: widget.dimension,
          fit: widget.fit,
          placeholderBuilder: (context) => AppSchimmer(
            width: widget.dimension,
            height: widget.dimension,
          ),
          errorBuilder: (context, error, stackTrace) => Icon(
            FluentIcons.photo_error,
            size: widget.dimension,
            color: FluentTheme.of(context).shadowColor,
          ),
        ),
      );
    } else {
      return SizedBox.square(
        dimension: widget.dimension,
        child: Image.network(
          widget.crest,
          width: widget.dimension,
          height: widget.dimension,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => Icon(
            FluentIcons.photo_error,
            size: widget.dimension,
            color: FluentTheme.of(context).shadowColor,
          ),
        ),
      );
    }
  }
}
