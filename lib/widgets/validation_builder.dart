part of '../formality.dart';

class ValidationBuilderController {
  late bool Function() validate;
}

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
  late final ValidationBuilderController _builderController;
  final List<ValidationController> _validationControllers = [];

  @override
  initState() {
    super.initState();

    _builderController = widget.controller ?? ValidationBuilderController();
    _builderController.validate = () {
      bool valid = true;

      for (final controller in _validationControllers) {
        if (!controller.validate() && controller.isRequired) {
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
    return ValidationProvider<T>(
      register: _register,
      unregister: _unregister,
      child: Builder(
        builder: (context) {
          return widget.builder(context, _builderController);
        },
      ),
    );
  }
}
