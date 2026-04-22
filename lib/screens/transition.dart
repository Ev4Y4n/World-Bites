import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Transition extends StatefulWidget {
  const Transition({super.key});

  @override
  State<Transition> createState() => _Transition();
}

class _Transition extends State<Transition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centra el contenido verticalmente
          children: [
            Lottie.network(
              'https://lottie.host/ea0381a6-ed07-41b0-bf92-f7390c4b0257/KNDd2fVkyJ.json',
            ),
            const SizedBox(height: 30),
            Text(
              'Preparando tu viaje...',
              style: GoogleFonts.barlow(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 42, 79, 114),)

            ),
          ],
        ),
      ),
    );
  }
}
