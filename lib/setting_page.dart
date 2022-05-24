import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            tileColor: Colors.amber,
            visualDensity: VisualDensity.compact,
            title: Text('Logout'),
            onTap: null,
            leading: Icon(Icons.login),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            tileColor: Colors.white,
            visualDensity: VisualDensity.compact,
            title: const Text('Logout'),
            onTap: () => {
              FirebaseAuth.instance.signOut(),
              Navigator.pushNamed(context, '/'),
            },
            leading: const Icon(Icons.login),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            tileColor: Colors.amber,
            visualDensity: VisualDensity.compact,
            title: Text('Logout'),
            onTap: null,
            leading: Icon(Icons.login),
          ),
        ),
      ],
    );
  }
}
