import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
<<<<<<< Updated upstream
import 'package:flutter_application_1/screens/intro_animation.dart';
=======
import 'package:flutter_application_1/screens/profile/profile.dart';
import 'package:flutter_application_1/screens/countries.dart';
>>>>>>> Stashed changes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
<<<<<<< Updated upstream
      home: const IntroAnimation(),
=======
      home: CountriesPage(),
>>>>>>> Stashed changes
    );
  }
}
