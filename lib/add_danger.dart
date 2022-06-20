import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'utils.dart';

class AddDangerPage extends StatefulWidget {
  const AddDangerPage({Key? key}) : super(key: key);

  @override
  State<AddDangerPage> createState() => _AddDangerPageState();
}

class _AddDangerPageState extends State<AddDangerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: const Text(
          'Report a problem',
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

  Widget _textInput(int line) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: TextField(
        //controller: controller.noteInputController,
        onTap: () {},
        maxLength: 1000,
        minLines: line,
        maxLines: line,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xfff0f4f5),
          contentPadding: const EdgeInsets.all(10.0),
          hintText: 'Aa',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 17.0,
            fontFamily: 'Roboto',
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _textHeader(BuildContext context, String name, String requirement) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 20.0),
        child: Text(
          name.toUpperCase() + requirement,
          style: const TextStyle(
            color: Color(0xff004a54),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      minimum: const EdgeInsets.all(20),
      child: Column(
        children: [
          udaptePosition(),
          const SizedBox(
            height: 15,
          ),
          // _textHeader(context, 'what do you want to be called ', '(optional)'),
          customTextForm(
            (value) => {
              print(value),
            },
            const Icon(Icons.person),
            'What do you want to be called',
            user!.displayName!.split(' ')[0],
          ),
          _textHeader(context, 'Whats going on ', '(optional)'),
          _textInput(4),
          _textHeader(context, 'other information ', '(optional)'),
          _textInput(4),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Position update'),
                    ),
                  );
                });
              },
              child: Container(
                decoration: const BoxDecoration(),
                padding: const EdgeInsets.all(10.0),
                child: const Text('Send'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<Address> udaptePosition() {
    return FutureBuilder(
      future: determinePosition(),
      builder: (BuildContext context, AsyncSnapshot<Address> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'loading',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        }
        return customTextForm(
          (value) => {
            print(value),
          },
          const Icon(Icons.near_me),
          'Your position',
          snapshot.data!.street,
        );
      },
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
