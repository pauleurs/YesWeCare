import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:paul/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _appScaffold({
    required Widget body,
    required BuildContext context,
  }) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(await _determinePosition());
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
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

  Widget _body() {
    //   EasyLoading.init();
    //  EasyLoading.show(status: 'loading...');

    return FutureBuilder<Address>(
      future: _determinePosition(),
      builder: (BuildContext context, AsyncSnapshot<Address> snapshot) {
        if (!snapshot.hasData) {
          return const Text('loading');
        }
        // EasyLoading.dismiss();
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                snapshot.data!.street,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _appScaffold(
      body: _body(),
      context: context,
    );
  }

  Future<Address> getAdresse(String lat, String lon) async {
    var url = Uri.parse(
      'https://api-adresse.data.gouv.frd/reverse/?lon=$lon&lat=$lat',
    );
    try {
      var response = await http.get(url);
      var rep = jsonDecode(response.body)['features'][0]['properties'];
      Address address = Address(
        street: rep['name'],
        postcode: rep['postcode'],
        city: rep['city'],
      );
      return address;
    } catch (e) {
      return Address(street: 'error');
      // return e.toString();
    }
  }

  Future<Address> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position pos = await Geolocator.getCurrentPosition();
    return getAdresse(pos.latitude.toString(), pos.longitude.toString());
  }
}
