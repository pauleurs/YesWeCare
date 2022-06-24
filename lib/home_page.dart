// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paul/danger_view.dart';
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
  List<String> allReportingRoute = <String>[];

  @override
  void initState() {
    super.initState();

    // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
    String _now = DateTime.now().second.toString();

    // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
    Timer _everySecond = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _now = DateTime.now().second.toString();
      });
    });
  }

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

  Future<Address> _getData() async {
    DataSnapshot myRep = await ref.get();
    DataSnapshot allDanger = await allDangers.get();
    allReportingRoute.clear();
    allReporting.clear();
    for (var element in allDanger.children) {
      if (element.key != FirebaseAuth.instance.currentUser!.uid) {
        for (var f in element.children) {
          allReportingRoute.add('/dangers/${element.key}/${f.key}');
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
                printAdress(
                    Address(street: 'loading', city: 'loading'), context),
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

  double getDistance(double pLat, double pLng, Address address) {
    final double distance =
        Geolocator.distanceBetween(pLat, pLng, address.lat, address.lon);
    return distance;
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
            printAdress(address, context),
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
            printMyDangers(),
            textHeader(context, 'Dangers report ', ' : ', size: 15),
            const SizedBox(height: 15),
            printAllDangers(address),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  ListView printMyDangers() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: myReporting.length >= 5 ? 5 : myReporting.length,
      itemBuilder: (BuildContext context, int i) {
        Danger danger = getDanger(myReporting[i]);
        return Card(
          child: ListTile(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return DangerPage(danger: danger);
                },
              );
            },
            leading: const Icon(
              Icons.warning,
              size: 45,
            ),
            title: Text('Your name : ${danger.name}'),
            subtitle: Text(
                'Whats going on :\n${danger.info}\nOther information :\n${danger.description}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  void checkNotification(String danger, int index, double distance) async {
    DatabaseReference check = FirebaseDatabase.instance.ref(
      '${allReportingRoute[index]}/user',
    );

    if (danger.lastIndexOf(FirebaseAuth.instance.currentUser!.uid) == -1 &&
        allReportingRoute[index] != '') {
      allReportingRoute[index] = '';
      await check.update({
        FirebaseAuth.instance.currentUser!.uid: true,
      });
      distance.ceil;
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 123,
          channelKey: 'basic',
          title: 'YesWeCare',
          body:
              '${parceString(danger, 'name:').toUpperCase()} needs help at ${distance.ceil()} meters\n${parceString(danger, 'address:')}',
        ),
      );
    }
  }

  Danger getDanger(String string) {
    DateTime date = DateTime.parse(parceString(string, 'date:'));
    return Danger(
      date: date,
      name: parceString(string, 'name:'),
      info: parceString(string, 'info:'),
      description: parceString(string, 'description:'),
      adress: Address(
        street: parceString(string, 'address:'),
        lat: double.parse(
          parceString(string, 'lat:'),
        ),
        lon: double.parse(
          parceString(string, 'lon:'),
        ),
      ),
    );
  }

  ListView printAllDangers(Address address) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allReporting.length >= 5 ? 5 : allReporting.length,
      itemBuilder: (BuildContext context, int i) {
        int length = allReporting.length - 1 - i;
        Danger danger = getDanger(allReporting[length]);
        double distance =
            getDistance(danger.adress.lat, danger.adress.lon, address);

        if (distance <= 3000) {
          checkNotification(allReporting[length], length, distance);
          return Card(
            child: ListTile(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return DangerPage(danger: danger);
                  },
                );
              },
              leading: const Icon(
                Icons.warning,
                size: 45,
              ),
              title: Text('${danger.name.toUpperCase()} needs help !'),
              subtitle: Text(
                  '${distance.ceil()} meters from you\nClick here for more details ...'),
              trailing: const Icon(Icons.navigate_next_sharp),
              isThreeLine: true,
            ),
          );
        }
        return Container();
      },
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
