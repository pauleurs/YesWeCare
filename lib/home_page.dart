import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
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
        onPressed: () {},
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
              fontSize: 30,
            ),
          ),
          Text(
            address.street,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return FutureBuilder<Address>(
      future: _determinePosition(),
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
        Address address = snapshot.data!;
        return Padding(
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
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    address = await _determinePosition();
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
      'https://api-adresse.data.gouv.fr/reverse/?lon=$lon&lat=$lat',
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

    Address address =
        await getAdresse(pos.latitude.toString(), pos.longitude.toString());
    address.lat = pos.latitude;
    address.lon = pos.longitude;
    return address;
  }

  Widget map(BuildContext context, Address address) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(address.lat, address.lon),
        zoom: 17,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(address.lat, address.lon),
              builder: (ctx) => Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/LoCos_Point.svg/1024px-LoCos_Point.svg.png'),
            ),
          ],
        ),
      ],
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap',
          onSourceTapped: () {},
        ),
      ],
    );
  }
}
