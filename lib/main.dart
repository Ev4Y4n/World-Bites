import 'package:flutter/material.dart';
import 'package:flutter_application_1/countries.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  debugPrint("EMPEZANDO MAIN");
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Bites',
      home: Scaffold(
        appBar: AppBar(title: const Text('First Route')),
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaPaises(),
                  ),
                );
              },
              child: const Text('ENTRAR'),
            );
          },
        ),
      ),
    );
  }
}


/*
flutter clean
flutter pub get
flutter run
 */