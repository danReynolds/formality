part of '../formality.dart';

typedef ValidationControllerListener = void Function(bool isValid);
typedef ValidationAnimationBuilder = Widget Function(
  Widget child,
  ValidationController controller,
);

class ValidationController {
  final Set<ValidationControllerListener> _listeners = {};

  ValidationControllerListener addListener(
    ValidationControllerListener listener,
  ) {
    _listeners.add(listener);
    return listener;
  }

  void removeListener(ValidationControllerListener listener) {
    _listeners.remove(listener);
  }

  void _onValidate(bool valid) {
    for (final listener in _listeners) {
      listener(valid);
    }
  }

  late bool Function() validate;

  /// Whether the validation is required and should fail the passing of the overall validation result.
  final bool isRequired;

  ValidationController({
    this.isRequired = true,
  });
}

class Validation extends StatefulWidget {
  /// Whether the validation is valid for the field.
  final bool valid;

  /// Whether the validation is required and should fail the the overall validation result.
  final bool isRequired;

  final Widget child;

  final ValidationController? controller;

  final Widget? error;

  final ValidationAnimationBuilder? childAnimationBuilder;
  final ValidationAnimationBuilder? errorAnimationBuilder;

  const Validation({
    super.key,
    required this.valid,
    required this.child,
    this.error,
    this.controller,
    this.childAnimationBuilder,
    this.errorAnimationBuilder,
    this.isRequired = true,
  });

  @override
  ValidationState createState() => ValidationState();

  static Widget result(
    ValidationResult? result, {
    required Widget child,
    ValidationController? controller,
    Widget? error,
  }) {
    return Validation(
      valid: result?.valid ?? true,
      controller: controller,
      error: error,
      child: child,
    );
  }
}

class ValidationState extends State<Validation> {
  late final ValidationProvider _validationProvider;

  bool _isRegistered = false;
  bool _showValidationError = false;

  late final ValidationController _validationController;
  late ValidationControllerListener _listener;

  @override
  void initState() {
    super.initState();

    _validationController = widget.controller ??
        ValidationController(isRequired: widget.isRequired);

    _validationController.validate = () {
      final isValid = widget.valid;

      if (!isValid && !_showValidationError) {
        setState(() {
          _showValidationError = !isValid;
        });
      }

      _validationController._onValidate(isValid);

      return isValid;
    };
  }

  @override
  dispose() {
    _validationProvider.unregister(_validationController);
    _validationController.removeListener(_listener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isRegistered) {
      _isRegistered = true;
      _validationProvider = ValidationProvider.of(context);
      _validationProvider.register(_validationController);
    }
  }

  @override
  build(context) {
    final errorWidget = widget.error;
    final childAnimationBuilder = widget.childAnimationBuilder;
    final errorAnimationBuilder = widget.errorAnimationBuilder;

    if (_showValidationError && widget.valid) {
      _showValidationError = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        childAnimationBuilder?.call(widget.child, _validationController) ??
            FormalityChildAnimation(
              controller: _validationController,
              child: widget.child,
            ),
        if (_showValidationError && errorWidget != null)
          errorAnimationBuilder?.call(errorWidget, _validationController) ??
              FormalityErrorAnimation(child: errorWidget),
      ],
    );
  }
}
