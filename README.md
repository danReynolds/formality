# Formality

A simple form validation library for Flutter.

## Example

```dart
class UserFormModel {
  final String firstName;
  final String lastName;

  UserFormModel({
    required this.firstName,
    required this.lastName,
  });
}

class MyPage extends StatelessWidget {
  @override
  build(context) {
    return FormBuilder(
      initialFormData: UserFormModel(firstName: 'John', lastName: ''),
      builder: (context, formData, controller) {
        final UserFormModel(:firstName, :lastName) = formData;

        return Column(
          children: [
            Validation(
              valid: firstName.isNotEmpty,
              child: TextFormField(
                initialValue: firstName,
                decoration: const InputDecoration(labelText: 'First name'),
                onChanged: (value) => controller.setForm(
                  formData.copyWith(firstName: value),
                ),
              ),
            ),
            Validation(
              valid: lastName.isNotEmpty,
              child: TextFormField(
                initialValue: lastName,
                decoration: const InputDecoration(labelText: 'Last name'),
                onChanged: (value) => controller.setForm(
                  formData.copyWith(lastName: value),
                },
              ),
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPress: () {
                if (controller.validate()) {
                  // Submit form
                }
              }
            )
          ],
        );
      }
    
  }

```

All validation widgets animate errors as shown below:

![Basic demo gif](./demo.gif).

Field animations can be customized using the `Validation.childAnimationBuilder` and `Validation.errorAnimationBuilder` builders.

## Required fields

Fields can be labeled as optional using the `Validation.required` field.

```dart
import 'package:flutter/material.dart';
import 'package:formality/formality.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Formality Example'),
        ),
        body: MyPage(),
      ),
    );
  }
}

class UserFormModel {
  final String name;
  final String description;

  UserFormModel({
    required this.name,
    required this.description,
  });

  UserFormModel copyWith({String? name, String? description}) {
    return UserFormModel(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.7,  // Limits the form width to 70% of the screen width
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                initialFormData: UserFormModel(
                  name: 'John Smith',
                  description: '',
                ),
                builder: (context, formData, controller) {
                  final UserFormModel(:name, :description) = formData;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Validation(
                        valid: name.isNotEmpty,
                        error: const Text("Name",
                          style: TextStyle(color: Colors.red),),
                        required: false,
                        child: TextFormField(
                          initialValue: name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          onChanged: (value) => controller.setForm(
                            formData.copyWith(name: value),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Validation(
                        valid: description.isNotEmpty,
                        error: const Text(
                          'Description cannot be empty',
                          style: TextStyle(color: Colors.red),
                        ),
                        child: TextFormField(
                          initialValue: description,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          onChanged: (value) {
                            controller.setForm(
                              formData.copyWith(description: value),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          if (controller.validate()) {
                            // Add your form submission logic here
                            print('Form is valid and submitted');
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```
