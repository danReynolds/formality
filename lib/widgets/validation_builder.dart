part of '../formality.dart';

/// The controller for triggering validation on all [Validation] widgets under the builder.
class ValidationBuilderController {
  late bool Function() validate;
}

/// A validation builder automatically finds all [Validation] widgets under it and groups them for validation
/// using the associated [ValidationBuilderController] controller.
class ValidationBuilder extends StatefulWidget {
  final ValidationBuilderController? controller;
  final Widget Function(
    BuildContext context,
    ValidationBuilderController controller,
  ) builder;

  const ValidationBuilder({
    super.key,
    required this.builder,
    this.controller,
  });

  @override
  ValidationBuilderState createState() => ValidationBuilderState();
}

class ValidationBuilderState<T> extends State<ValidationBuilder> {
  late final ValidationBuilderController _groupController;
  final List<ValidationController> _validationControllers = [];

  @override
  initState() {
    super.initState();

    _groupController = widget.controller ?? ValidationBuilderController();
    _groupController.validate = () {
      bool valid = true;

      // First go through and determine if the group is valid overall.
      for (final controller in _validationControllers) {
        if (controller.required && !controller.validate()) {
          valid = false;
        }
      }

      // Then if not valid, run individual validation on all non-required fields in order to have them
      // show their validation errors if present as well.
      if (!valid) {
        for (final controller in _validationControllers) {
          if (!controller.required) {
            controller.validate();
          }
        }
      }

      return valid;
    };
  }

  void _register(ValidationController controller) {
    _validationControllers.add(controller);
  }

  void _unregister(ValidationController controller) {
    _validationControllers.remove(controller);
  }

  @override
  build(context) {
    return _ValidationProvider<T>(
      register: _register,
      unregister: _unregister,
      child: Builder(
        builder: (context) {
          return widget.builder(context, _groupController);
        },
      ),
    );
  }
}
