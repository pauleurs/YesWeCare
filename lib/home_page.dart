import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  Widget _appScaffold({required Widget body}) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          _saveButton(),
        ],
      ),
      body: body,
    );
  }

  Widget _saveButton() {
    return TextButton(
      onPressed: () {
        print("Home");
        FirebaseAuth.instance.signOut();
      },
      child: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  FirebaseAuth.instance.signOut();
    return _appScaffold(body: _body());
  }
}
