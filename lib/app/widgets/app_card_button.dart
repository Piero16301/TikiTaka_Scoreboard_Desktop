import 'package:fluent_ui/fluent_ui.dart';

class AppCardButton extends StatelessWidget {
  const AppCardButton({
    this.onPressed,
    this.child,
    super.key,
  });

  final void Function()? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Button(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
