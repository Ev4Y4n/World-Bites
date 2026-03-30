import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class Recipe extends StatefulWidget {
  //Recibe los datos de la receta desde la pantalla de categoría
  final String image, foodname;
  final List<dynamic> ingredients, steps;

  Recipe({
    super.key,
    required this.foodname,
    required this.image,
    required this.ingredients,
    required this.steps,
  });

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.network(
              // Imagen de la receta en la parte superior
              widget.image,
              width: MediaQuery.of(context).size.width,
              height: 400,
              fit: BoxFit.cover,
            ),
            Container(
              // Contenedor que muestra el nombre, ingredientes y pasos
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 1.1,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.foodname,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 10.0),
                    Text(
                      "Ingredientes",
                      style: AppWidget.lightfeildtextstyle(),
                    ),
                    SizedBox(height: 10.0), // Espacio entre el título "Ingredientes" y la lista de ingredientes
                    ...widget.ingredients.map( // Muestra la lista de ingredientes
                      (ing) => Text("${ing['quantity']} ${ing['name']}"), // Muestra la cantidad y el nombre de cada ingrediente
                    ), // Lista de ingredientes
                    SizedBox(height: 20.0),
                    Text(
                      "Instrucciones",
                      style: AppWidget.lightfeildtextstyle(),
                    ),
                    SizedBox(height: 10.0),
                    ...widget.steps.map((stepGroup) {
                      String tag = stepGroup['tag'] ?? '';
                      List<dynamic> stepsList = stepGroup['steps'] ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tag.isNotEmpty)
                            Text(
                              tag,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ...stepsList.map((s) => Text("- $s")),
                          SizedBox(height: 10),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
