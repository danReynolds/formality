part of '../formality.dart';

/// The controller for the form used to validate, update and submit its data.
class FormController<T> {
  late bool Function() validate;
  late void Function(T updatedData) setForm;
  late void Function([T? formData]) submit;
}

// A controlled [FormProvider] requires consumers to wire up an onChange handler
// and pass down the data to rebuild with. An [UncntrolledFormProvider], by contrast,
// manages its own data.
class FormBuilder<T> extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final Widget Function(
    BuildContext context,
    T formData,
    FormController<T> controller,
  ) builder;
  final T initialFormData;
  final void Function(T formData)? onChange;
  final void Function(T formData)? onSubmit;

  const FormBuilder({
    super.key,
    required this.builder,
    required this.initialFormData,
    this.onChange,
    this.onSubmit,
    this.formKey,
  });

  @override
  FormBuilderState createState() => FormBuilderState<T>();
}

class FormBuilderState<T> extends State<FormBuilder<T>> {
  final _formController = FormController<T>();
  final _validationController = ValidationBuilderController();
  late T _formData;

  @override
  initState() {
    super.initState();

    _formData = widget.initialFormData;
    _formController.setForm = (data) {
      setState(() {
        _formData = data;
      });
      widget.onChange?.call(data);
    };
    _formController.validate = () {
      return _validationController.validate();
    };
    _formController.submit = ([T? formData]) {
      if (formData != null) {
        _formController.setForm(formData);
      }

      if (_formController.validate()) {
        widget.onSubmit?.call(_formData);
      }
    };
  }

  @override
  build(context) {
    return ValidationBuilder(
      controller: _validationController,
      builder: (context, _) {
        return widget.builder(context, _formData, _formController);
      },
    );
  }
}
