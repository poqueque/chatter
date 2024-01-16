import 'package:chatter/firebase_options.dart';
import 'package:chatter/providers/firebase_provider.dart';
import 'package:chatter/providers/message_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FirebaseProvider(),
      child: ChangeNotifierProvider(
        create: (BuildContext context) => MessageProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FirebaseUILocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es'),
            Locale('ca'),
            Locale('en'),
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Splash(),
        ),
      ),
    );
  }
}

Future<void> backgroundMessageHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  debugPrint("Missatge rebut en background: ${remoteMessage.messageId}");
}
