import 'package:flutter/material.dart';
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
        child: Lottie.network(
          'https://lottie.host/4ab92b77-ccb6-4c00-ada2-ab7962998a98/mNaph59n5u.lottie',
        ),
      ),
    );
  }
}
