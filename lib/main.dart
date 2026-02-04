import 'package:flutter/material.dart';
import 'package:flutter_application_1/countries.dart';

void main() {
  debugPrint("EMPEZANDO MAIN");
  runApp(const MyApp());
  //cargarJson();
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