import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'categories.dart';


class Pais {
  final String id;
  final String nombre;

  Pais({required this.id, required this.nombre});
}

class PantallaPaises extends StatefulWidget {
  const PantallaPaises({super.key});

  @override
  State<PantallaPaises> createState() => _PantallaPaisesState();
}

class _PantallaPaisesState extends State<PantallaPaises> {
  List<Pais> paises = [];

  Future<void> cargarPaises() async {
    final String response =
        await rootBundle.loadString('assets/json/paises.json');

    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> countries = data['countries'];

    setState(() {
      paises = countries
          .map((c) => Pais(
                id: c['id'],
                nombre: c['name'],
              ))
          .toList();
    });
  }

  void irACategorias(Pais pais) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaCategorias(
          paisId: pais.id,
          paisNombre: pais.nombre,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Países')),
      body: paises.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: cargarPaises,
                child: const Text('Cargar países'),
              ),
            )
          : ListView.builder(
              itemCount: paises.length,
              itemBuilder: (context, index) {
                final pais = paises[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => irACategorias(pais),
                    child: Text(pais.nombre),
                  ),
                );
              },
            ),
    );
  }
}
