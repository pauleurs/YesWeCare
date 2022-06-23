// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:paul/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref(
    "/dangers/${FirebaseAuth.instance.currentUser!.uid}",
  );
  DatabaseReference allDangers = FirebaseDatabase.instance.ref(
    "/dangers",
  );

  List<String> myReporting = <String>[];
  List<String> allReporting = <String>[];

  Widget _appScaffold({
    required Widget body,
    required BuildContext context,
  }) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/danger');
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.error),
      ),
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
          _settingButton(context),
        ],
      ),
      body: body,
    );
  }

  Widget _settingButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/setting');
      },
      child: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
    );
  }

  Widget printAdress(Address address) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.city,
            style: const TextStyle(
              fontSize: 27,
            ),
          ),
          Text(
            address.street,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  Future<Address> _getData() async {
    DataSnapshot myRep = await ref.get();
    DataSnapshot allDanger = await allDangers.get();

    FirebaseAuth.instance.currentUser!.uid;

    for (var element in allDanger.children) {
      if (element.key != FirebaseAuth.instance.currentUser!.uid) {
        for (var f in element.children) {
          allReporting.add(f.value.toString());
        }
      }
    }
    myReporting.clear();
    for (var element in myRep.children) {
      String tempo = element.value.toString();
      myReporting.add(tempo);
    }

    return determinePosition();
  }

  Widget _body() {
    return FutureBuilder<Address>(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot<Address> snapshot) {
        if (!snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                printAdress(Address(street: 'loading', city: 'loading')),
                const SizedBox(height: 185),
                const Text('loading ...', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 200),
                textHeader(context, 'My Reporting History ', ' : ', size: 15),
                textHeader(context, 'Dangers report ', ' : ', size: 15),
              ],
            ),
          );
        }
        Address address = snapshot.data!;

        return pageLoad(address, context);
      },
    );
  }

  String parceString(String start, String pattern) {
    int index = start.lastIndexOf(pattern);
    int saveIndex = index;
    while (start[index] != ',' && start[index] != '}') {
      index = index + 1;
    }
    return start.substring(saveIndex + pattern.length + 1, index);
  }

  SingleChildScrollView pageLoad(Address address, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            printAdress(address),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: SizedBox(
                height: 300,
                child: map(context, address),
              ),
            ),
            const SizedBox(height: 15),
            buttonUpdate(address, context),
            const SizedBox(height: 15),
            textHeader(context, 'My Reporting History ', ' : ', size: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myReporting.length >= 5 ? 5 : myReporting.length,
              itemBuilder: (BuildContext context, int i) {
                DateTime date = DateTime.parse(
                  parceString(myReporting[i], 'date:'),
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    printDate(date),
                    Text(
                      'Your name : ${parceString(myReporting[i], 'name:')}',
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Text(
                        'Whats going on :\n${parceString(myReporting[i], 'description:')}'),
                    Text(
                      'Other information :\n${parceString(myReporting[i], 'info:')}',
                    ),
                    const SizedBox(height: 15),
                    const Divider(height: 1, indent: 70),
                  ],
                );
              },
            ),
            textHeader(context, 'Dangers report ', ' : ', size: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allReporting.length >= 5 ? 5 : allReporting.length,
              itemBuilder: (BuildContext context, int i) {
                int length = allReporting.length - 1 - i;
                DateTime date =
                    DateTime.parse(parceString(allReporting[length], 'date:'));
                print(length);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      '${parceString(allReporting[length], 'name:').toUpperCase()} needs help',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    printDate(date, bold: false),
                    Text(
                      'Address :\n${parceString(allReporting[length], 'address:')}',
                    ),
                    Text(
                      'Whats going on :\n${parceString(allReporting[length], 'description:')}',
                    ),
                    Text(
                      'Other information :\n${parceString(allReporting[length], 'info:')}',
                    ),
                    const SizedBox(height: 15),
                    const Divider(height: 1, indent: 70),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget printDate(
    DateTime date, {
    bool bold = true,
  }) {
    return Text(
      'Le ${date.day}/0${date.month}/${date.year} a ${date.hour}H${date.minute}',
      style: TextStyle(
        fontSize: bold ? 16 : 14,
        fontWeight: bold ? FontWeight.bold : null,
      ),
    );
  }

  Center buttonUpdate(Address address, BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          address = await determinePosition();

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
          child: const Text('Update position'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _appScaffold(
      body: _body(),
      context: context,
    );
  }
}
