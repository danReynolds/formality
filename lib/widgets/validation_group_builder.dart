part of '../formality.dart';

/// The controller for triggering validation on all [Validation] elements in the group.
class ValidationGroupController {
  late bool Function() validate;
}

/// A validation group builder automatically groups all [Validation] widgets under it into a validation group
/// which can be validated by its associated [ValidationGroupController] controller.
class ValidationGroupBuilder extends StatefulWidget {
  final ValidationGroupController? controller;
  final Widget Function(
    BuildContext context,
    ValidationGroupController controller,
  ) builder;

  const ValidationGroupBuilder({
    super.key,
    required this.builder,
    this.controller,
  });

  @override
  ValidationGroupBuilderState createState() => ValidationGroupBuilderState();
}

class ValidationGroupBuilderState<T> extends State<ValidationGroupBuilder> {
  late final ValidationGroupController _groupController;
  final List<ValidationController> _validationControllers = [];

  @override
  initState() {
    super.initState();

    _groupController = widget.controller ?? ValidationGroupController();
    _groupController.validate = () {
      bool valid = true;
      for (final controller in _validationControllers) {
        if (!controller.validate() && controller.required) {
          valid = false;
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
