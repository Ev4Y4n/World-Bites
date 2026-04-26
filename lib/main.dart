import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/layout/nav_bar.dart';
import 'package:flutter_application_1/providers/app_state.dart';
import 'package:flutter_application_1/screens/comming_soon.dart';
import 'package:flutter_application_1/screens/intro_animation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Iniciar la aplicación con el proveedor de estado para manejar la selección del país
  runApp(ChangeNotifierProvider(create: (_) => AppState(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'World Bites',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 42, 79, 114),
        ),
        useMaterial3: true,
      ),
      home: const CommingSoon(),
      //home: const NavBar(),
    );
  }
}
