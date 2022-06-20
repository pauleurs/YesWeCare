import 'package:flutter/material.dart';
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
}
