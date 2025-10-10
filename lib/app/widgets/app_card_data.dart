import 'package:fluent_ui/fluent_ui.dart';

class AppCardData extends StatelessWidget {
  const AppCardData({
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card(
        child: child,
      ),
    );
  }
}
