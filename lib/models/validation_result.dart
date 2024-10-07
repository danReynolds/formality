part of '../formality.dart';

typedef Validator = ValidationResult Function(String? text);

class ValidationResult {
  final String message;
  final bool valid;

  ValidationResult({
    required this.message,
    required this.valid,
  });

  ValidationResult.valid()
      : message = '',
        valid = true;

  ValidationResult.error(this.message) : valid = false;
}
