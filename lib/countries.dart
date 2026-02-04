import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<void> cargarJson() async {
  final String response = await rootBundle.loadString('assets/json/paises.json');
  final data = json.decode(response);
  debugPrint("CARGANDO DATOS JSON ${data['name'].toString()}");
}

class PantallaPaises extends StatelessWidget {
  const PantallaPaises({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Route')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            cargarJson();
            
          },
          child: const Text('Cargar Paises'),
        ),
      ),
    );
  }
}

