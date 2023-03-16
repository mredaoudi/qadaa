import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qadaa/providers/people_provider.dart';

// Create a Form widget.
class UserForm extends StatefulWidget {
  final bool firstTime;
  const UserForm({super.key, required this.firstTime});

  @override
  UserFormState createState() {
    return UserFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class UserFormState extends State<UserForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<UserFormState>.
  final _formKey = GlobalKey<FormState>();

  String text = "";

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 100, 100, 50),
              child: Image.asset('assets/icon/icon.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username',
                ),
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return const Color(0xFFD6D6D6); // Disabled color
                    }
                    return const Color(0xFF4E6E81); // Regular color
                  }),
                  minimumSize: const MaterialStatePropertyAll(Size(50, 50)),
                ),
                onPressed: text == ''
                    ? null
                    : () async {
                        peopleProvider.createPerson(
                          name: text,
                          firstTime: widget.firstTime,
                        );
                        Navigator.pushNamed(context, '/');
                      },
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
