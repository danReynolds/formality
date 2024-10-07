part of '../formality.dart';

class _ValidationProvider<T> extends InheritedWidget {
  const _ValidationProvider({
    super.key,
    required super.child,
    required this.register,
    required this.unregister,
  });

  final void Function(ValidationController controller) register;
  final void Function(ValidationController controller) unregister;

  static _ValidationProvider<T> of<T>(BuildContext context) {
    final _ValidationProvider<T>? result =
        context.dependOnInheritedWidgetOfExactType<_ValidationProvider<T>>();
    assert(result != null, 'No _ValidationProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_ValidationProvider oldWidget) =>
      oldWidget.register != register ||
      register != oldWidget.register ||
      unregister != oldWidget.unregister;
}
