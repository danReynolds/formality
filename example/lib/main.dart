import 'package:flutter/material.dart';
import 'package:formality/formality.dart';

void main() {
  runApp(const MyApp());
}

class ExampleFormModel {
  final String firstName;
  final String lastName;
  final String email;

  ExampleFormModel({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
  });

  ExampleFormModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return ExampleFormModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }
}

final nameRegex = RegExp(r"[a-zA-Z0-9 \.´'‘’]");
final emailRegex = RegExp(
  r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleFormPage(),
    );
  }
}

class ExampleFormPage extends StatelessWidget {
  const ExampleFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formality')),
      body: FormBuilder(
        initialFormData: ExampleFormModel(firstName: 'John'),
        builder: (context, formData, controller) {
          final ExampleFormModel(:firstName, :lastName, :email) = formData;

          return Center(
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Validation(
                    valid:
                        nameRegex.hasMatch(firstName) && firstName.isNotEmpty,
                    error: const Text(
                      'Invalid first name',
                      style: TextStyle(color: Colors.red),
                    ),
                    child: TextFormField(
                      initialValue: firstName,
                      decoration: const InputDecoration(
                        labelText: 'First name',
                      ),
                      onChanged: (value) {
                        controller.setForm(
                          formData.copyWith(firstName: value),
                        );
                      },
                    ),
                  ),
                  Validation(
                    valid: nameRegex.hasMatch(lastName) && lastName.isNotEmpty,
                    error: const Text(
                      'Invalid last name',
                      style: TextStyle(color: Colors.red),
                    ),
                    child: TextFormField(
                      initialValue: lastName,
                      decoration: const InputDecoration(
                        labelText: 'Last name',
                      ),
                      onChanged: (value) {
                        controller.setForm(
                          formData.copyWith(lastName: value),
                        );
                      },
                    ),
                  ),
                  Validation(
                    valid: emailRegex.hasMatch(email),
                    error: const Text(
                      'Invalid email',
                      style: TextStyle(color: Colors.red),
                    ),
                    child: TextFormField(
                      initialValue: email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        controller.setForm(
                          formData.copyWith(email: value),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Submitted!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error!'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
