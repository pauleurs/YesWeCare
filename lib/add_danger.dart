import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'utils.dart';

import 'package:geolocator/geolocator.dart';

class AddDangerPage extends StatefulWidget {
  const AddDangerPage({Key? key}) : super(key: key);

  @override
  State<AddDangerPage> createState() => _AddDangerPageState();
}

class _AddDangerPageState extends State<AddDangerPage> {
  String street = '';
  User? user = FirebaseAuth.instance.currentUser;
  Address? address;

  TextEditingController info = TextEditingController();
  TextEditingController hapend = TextEditingController();

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

  Widget _textInput(int line, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: TextField(
        controller: controller,
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

  Widget _body(BuildContext context) {
    String name = user!.displayName!.split(' ')[0];
    return SafeArea(
      minimum: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            udaptePosition(),
            const SizedBox(
              height: 15,
            ),
            customTextForm(
              (value) => {
                name = value,
              },
              const Icon(Icons.person),
              'What do you want to be called',
              user!.displayName!.split(' ')[0],
            ),
            textHeader(context, 'Whats going on ', '(optional)'),
            _textInput(4, hapend),
            textHeader(context, 'other information ', '(optional)'),
            _textInput(4, info),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  DatabaseReference ref = FirebaseDatabase.instance.ref(
                    '/dangers/${FirebaseAuth.instance.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}',
                  );
                  await ref.set({
                    "name": name,
                    "info": info.text,
                    "description": hapend.text,
                    "address": street,
                    "date": DateTime.now().toString(),
                    "lat": address?.lat,
                    "lon": address?.lon,
                  });
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request send'),
                      ),
                    );
                    Navigator.pop(context);
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
        address = snapshot.data!;
        street = snapshot.data!.street;
        return customTextForm(
          (value) => {
            street = value,
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
