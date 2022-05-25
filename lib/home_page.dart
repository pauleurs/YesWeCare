import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _appScaffold({
    required Widget body,
    required BuildContext context,
  }) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
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
          _saveButton(context),
        ],
      ),
      body: body,
    );
  }

  Widget _saveButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/setting');
        // FirebaseAuth.instance.signOut();
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
        children: const <Widget>[
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  FirebaseAuth.instance.signOut();
    return _appScaffold(
      body: _body(),
      context: context,
    );
  }
}
