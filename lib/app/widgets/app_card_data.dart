import 'package:fluent_ui/fluent_ui.dart';

class AppCardData extends StatelessWidget {
  const AppCardData({
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.cardPadding = const EdgeInsets.all(12),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry cardPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card(
        padding: cardPadding,
        child: child,
      ),
    );
  }
}
