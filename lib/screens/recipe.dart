import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class Recipe extends StatefulWidget {
  //Recibe los datos de la receta desde la pantalla de categoría
  final String image, foodname, difficulty;
  final List<dynamic> ingredients, steps, tags;
  final int kcal, prepTime, servings;
  bool isFavorite;

  Recipe({
    super.key,
    required this.foodname,
    required this.difficulty,
    required this.isFavorite,
    required this.image,
    required this.ingredients,
    required this.kcal,
    required this.prepTime,
    required this.servings,
    required this.steps,
    required this.tags,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width:
                              220, // Limita el ancho del nombre de la receta para evitar desbordamientos
                          child: Text(
                            widget.foodname,
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (widget.servings != 0)
                          Row(
                            children: [
                              Icon(Icons.people),
                              SizedBox(width: 5.0),
                              Text("${widget.servings} porciones"),
                            ],
                          ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...widget.prepTime != 0
                            ? [
                                Row(
                                  children: [
                                    Icon(Icons.timer),
                                    SizedBox(width: 5.0),
                                    Text("${widget.prepTime} min"),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                              ]
                            : [],
                        // Muestra el número de porciones si es diferente de 0
                        ...widget.kcal != 0
                            ? [
                                Row(
                                  children: [
                                    Icon(Icons.local_fire_department),
                                    SizedBox(width: 5.0),
                                    Text("${widget.kcal} kcal"),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                              ]
                            : [], // Muestra las calorías si es diferente de 0
                        ...widget.difficulty.isNotEmpty
                            ? [
                                Row(
                                  children: [
                                    Icon(Icons.bar_chart),
                                    SizedBox(width: 5.0),
                                    Text(widget.difficulty),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                              ]
                            : [],
                      ],
                    ),
                    // Muestra el tiempo de preparación si es diferente de 0
                    // Muestra la dificultad si no está vacía
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(222, 146, 176, 172),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.local_dining,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              size: 14,
                            ),
                          ),
                          Text(
                            "Ingredientes",
                            style: AppWidget.lightfeildtextstyle().copyWith(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ), // Espacio entre el título "Ingredientes" y la lista de ingredientes
                    ...widget.ingredients.map(
                      // Muestra la lista de ingredientes
                      (ing) => Text(
                        "${ing['name']} -- ${ing['quantity']}",
                      ), // Muestra la cantidad y el nombre de cada ingrediente
                    ), // Lista de ingredientes
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(222, 146, 176, 172),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.menu_book,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              size: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Instrucciones",
                            style: AppWidget.lightfeildtextstyle().copyWith(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ...widget.steps.map((stepGroup) {
                      String tag = stepGroup['tag'] ?? '';
                      List<dynamic> stepsList = stepGroup['steps'] ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tag.isNotEmpty)
                            ...stepsList.asMap().entries.map((entry) {
                              int index = entry.key;
                              String step = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  "${index + 1}. $step",
                                ),
                              ); // Enumeración 1., 2., 3....
                            }).toList(),
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
