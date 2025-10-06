import 'package:fluent_ui/fluent_ui.dart';
import 'package:text_scroll/text_scroll.dart';

class ScrollText extends StatelessWidget {
  const ScrollText({
    required this.text,
    this.style = const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    this.textAlign,
    super.key,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return TextScroll(
      text,
      textAlign: textAlign,
      pauseBetween: const Duration(seconds: 1),
      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
      style: style,
    );
  }
}
