import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PantallaPaises extends StatefulWidget {
  const PantallaPaises({super.key});

  @override
  State<PantallaPaises> createState() => _PantallaPaisesState();
}

class _PantallaPaisesState extends State<PantallaPaises> {
  List<String> nombres = [];

  Future<void> cargarJson() async {
    final String response =
        await rootBundle.loadString('assets/json/paises.json');

    final Map<String, dynamic> data = json.decode(response);

    final List<dynamic> countries = data['countries'];

    setState(() {
      nombres = countries.map((c) => c['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Países')),
      body: nombres.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: cargarJson,
                child: const Text('Cargar países'),
              ),
            )
          : ListView.builder(
              itemCount: nombres.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint(nombres[index]);
                    },
                    child: Text(nombres[index]),
                  ),
                );
              },
            ),
    );
  }
}
