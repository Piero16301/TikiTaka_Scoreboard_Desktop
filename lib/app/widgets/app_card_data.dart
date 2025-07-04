import 'package:fluent_ui/fluent_ui.dart';

class AppCardData extends StatelessWidget {
  const AppCardData({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        child: child,
      ),
    );
  }
}
