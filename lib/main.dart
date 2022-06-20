import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:paul/home_page.dart';
import 'package:paul/onboarding.dart';
import 'package:paul/setting_page.dart';
import 'firebase_options.dart';
import 'login_register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: '',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/home': (context) => const HomePage(),
        '/setting': (context) => const SettingPage(),
        '/onBoarding': (context) => const Onboarding(),
      },
    ),
  );
}

class YesWeCare extends StatelessWidget {
  const YesWeCare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthGate(),
    );
  }
}
