// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paul/utils.dart';

class DangerPage extends StatefulWidget {
  final Danger danger;
  const DangerPage({Key? key, required this.danger}) : super(key: key);

  @override
  State<DangerPage> createState() => _DangerPageState();
}

class _DangerPageState extends State<DangerPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String firstName = '';
  String lastName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: const Text(
          'Detail',
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
    return SingleChildScrollView(
      child: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            printAdress(
                Address(
                    street: widget.danger.adress.street,
                    city: '${widget.danger.name} is at :'),
                context),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: SizedBox(
                height: 200,
                width: 300,
                child: map(context, widget.danger.adress),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Whats going on :\n${widget.danger.description}',
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 17),
            ),
            Text(
              'Other information :\n${widget.danger.info}',
              style: const TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
