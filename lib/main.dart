import 'package:flutter/material.dart';

// Import condicional: en Windows usa firebase_stub.dart, en el resto firebase_real.dart
import 'firebase_stub.dart'
    if (dart.library.io) 'firebase_real.dart';

import 'package:flutter_application_1/layout/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // En Windows no hace nada; en Android/iOS/Web inicializa Firebase normal
  await FirebaseStub.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'World Bites',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavBar(),
    );
  }
}