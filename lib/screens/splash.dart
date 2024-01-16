import 'package:chatter/styles/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/firebase_provider.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String status = "Inicilitzant aplicació...";

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat, size: 96, color: AppStyles.orange),
            AppStyles.separator,
            Text(
              status,
              style: AppStyles.mediumText,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> init() async {
    Provider.of<FirebaseProvider>(context, listen: false).init();
    await Future.delayed(const Duration(milliseconds: 500));
    status = "Carregant (25%)";
    setState(() {});
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("Podem enviar missatges");
    }

    await Future.delayed(const Duration(milliseconds: 500));
    status = "Carregant (50%)";
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
    status = "Carregant (75%)";
    setState(() {});

    if (FirebaseAuth.instance.currentUser == null) {
      final providers = [EmailAuthProvider()];
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(
              providers: providers,
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  //Goto to Home
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                }),
                AuthStateChangeAction<UserCreated>((context, state) {
                  //Goto to Home
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                }),
              ],
            ),
          ),
        );
      }
    } else {
      //Goto to Home
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    }

    status = "Carregant (100%)";
    setState(() {});
  }
}
