import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;
  String? firstName;
  String? lastName;
  String? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            String newName = '${firstName!} ${lastName!}';
            user!.updateDisplayName(newName);

            Navigator.pushNamed(context, '/home');
          }
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.skip_next),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: const Text(
          'Onboarding',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 3,
              child: Image.network(
                  'https://cdn.voelkl.com/storage/user_upload/voelkl/Sustainability/Yes-we-care-Voelkl.png'),
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: user?.email,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => lastName = value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email *',
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onChanged: (value) => phone = value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone *',
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              onChanged: (value) => firstName = value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First name *',
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              onChanged: (value) => lastName = value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Last name *',
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
