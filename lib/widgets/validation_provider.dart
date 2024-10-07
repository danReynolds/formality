part of '../formality.dart';

class ValidationProvider<T> extends InheritedWidget {
  const ValidationProvider({
    super.key,
    required super.child,
    required this.register,
    required this.unregister,
  });

  final void Function(ValidationController controller) register;
  final void Function(ValidationController controller) unregister;

  static ValidationProvider<T> of<T>(BuildContext context) {
    final ValidationProvider<T>? result =
        context.dependOnInheritedWidgetOfExactType<ValidationProvider<T>>();
    assert(result != null, 'No ValidationProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ValidationProvider oldWidget) =>
      oldWidget.register != register ||
      register != oldWidget.register ||
      unregister != oldWidget.unregister;
}
