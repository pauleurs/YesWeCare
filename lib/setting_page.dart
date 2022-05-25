import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String firstName = '';
  String lastName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          _saveButton(context),
        ],
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: const Text(
          'Setting',
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

  Widget _saveButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          user!.updateDisplayName('${firstName} ${lastName}');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Data save'),
          ));
          Navigator.pushNamed(context, '/home');
        },
        child: const Text('Save'));
  }

  Widget _body(BuildContext context) {
    if (user!.displayName != null) {
      var firstLastName = user!.displayName!.split(' ');
      firstName = firstLastName.first;
      lastName = firstLastName[1];
    }
    String email = user!.email!;

    return SafeArea(
      minimum: const EdgeInsets.all(20),
      child: Column(
        children: [
          customTextForm(
            (value) => firstName = value,
            const Icon(Icons.person),
            'First name',
            firstName,
          ),
          const SizedBox(height: 15),
          customTextForm(
            (value) => {
              lastName = value,
            },
            const Icon(Icons.person),
            'Last name',
            lastName,
          ),
          const SizedBox(height: 15),
          customTextForm(
            (value) => {
              lastName = email,
            },
            const Icon(Icons.mail),
            'Email',
            email,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget customPadding(Function() onTap, String title, Icon icon) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        tileColor: Colors.red,
        visualDensity: VisualDensity.compact,
        title: Text(title),
        onTap: onTap,
        leading: icon,
      ),
    );
  }

  Widget customTextForm(Function(String) onChanged, Icon icon, String labelText,
      String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
      onChanged: (value) => onChanged(value),
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: labelText,
        prefixIcon: icon,
      ),
    );
  }
}
