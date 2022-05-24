// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
              headerBuilder: (context, constraints, _) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                        'https://cdn.voelkl.com/storage/user_upload/voelkl/Sustainability/Yes-we-care-Voelkl.png'),
                  ),
                );
              },
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                  clientId:
                      '977456002632-njdn2ls6u0bi6f5aggc2iarmkq2v2a48.apps.googleusercontent.com',
                ),
              ]);
        } else {
          Future.delayed(Duration.zero, () {
            Navigator.pushNamed(context, '/home');
          });
        }
        return const SizedBox();
      },
    );
  }
}
