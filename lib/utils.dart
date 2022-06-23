import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Address {
  String street;
  String postcode;
  String city;
  double lon;
  double lat;
  Address({
    this.street = '',
    this.postcode = '',
    this.city = '',
    this.lat = 0,
    this.lon = 0,
  });
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

Future<Address> determinePosition() async {
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

Widget textHeader(
  BuildContext context,
  String name,
  String requirement, {
  double size = 14,
}) {
  return Align(
    child: Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 20.0),
      child: Text(
        name.toUpperCase() + requirement,
        style: TextStyle(
          color: const Color(0xff004a54),
          fontSize: size,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
