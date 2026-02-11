import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_application_1/entities/category_entity.dart';
import 'package:flutter_application_1/recipe.dart';

class PantallaCategorias extends StatefulWidget {
  final String paisId;
  final String paisNombre;

  const PantallaCategorias({
    super.key,
    required this.paisId,
    required this.paisNombre,
  });

  @override
  State<PantallaCategorias> createState() => _PantallaCategoriasState();
}

class _PantallaCategoriasState extends State<PantallaCategorias> {
  List<Categoria> categorias = [];
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarCategorias();
  }

  Future<void> cargarCategorias() async {
    try {
      final paisId = widget.paisId.trim().toLowerCase();

      final response = await rootBundle.loadString(
        'assets/json/categorias_$paisId.json',
      );

      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> cats = data['categories'];

      setState(() {
        categorias = cats
            .map(
              (c) => Categoria(
                id: c['id'],
                nombre: c['name'],
                icono: c['icon'],
                recetas: c['recipes'],
              ),
            )
            .toList();
        cargando = false;
      });
    } catch (e) {
      setState(() {
        cargando = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.paisNombre)),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text('Error: $error'))
          : ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    leading: Image.network(
                      categoria.icono,
                      width: 40,
                      height: 40,
                      errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                    ),
                    title: Text(
                      categoria.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: categoria.recetas.map<Widget>((receta) {
                      return ListTile(
                        leading: const Icon(Icons.restaurant_menu),
                        title: Text(receta['name']),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          debugPrint('Receta seleccionada: ${receta['id']}');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PantallaRecetas(
                                id: receta['id'],
                                name: receta['name'],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
