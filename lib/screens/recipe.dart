import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/ui_elements/chatbot_button.dart';
import 'package:flutter_application_1/screens/ui_elements/favorite_button.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class Recipe extends StatefulWidget {
  final String image, foodname, difficulty;
  final List<dynamic> ingredients, steps, tags;
  final int kcal, prepTime, servings;
  final dynamic doc;

  const Recipe({
    super.key,
    required this.foodname,
    required this.difficulty,
    required this.image,
    required this.ingredients,
    required this.kcal,
    required this.prepTime,
    required this.servings,
    required this.steps,
    required this.tags,
    required this.doc,
  });

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  late List<bool> checkedIngredients;

  @override
  void initState() {
    super.initState();
    checkedIngredients = List.generate(widget.ingredients.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = widget.ingredients;
    final steps = widget.steps;

    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            widget.image.isNotEmpty
                ? widget.image
                : 'https://via.placeholder.com/400',
            width: MediaQuery.of(context).size.width,
            height: 400,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              color: Colors.grey,
              child: const Icon(Icons.image_not_supported, size: 50),
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(136, 97, 87, 87),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(child: 
            const ChatbotButton(),
            top: 110,
            left: 20,
          ),

          Positioned(
            top: 40,
            right: 20,
            child: FavoriteButton(recipeId: widget.doc.id),
          ),

          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width / 1.1,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
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
                        width: 220,
                        child: Text(
                          widget.foodname,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (widget.servings != 0)
                        Row(
                          children: [
                            const Icon(Icons.people),
                            const SizedBox(width: 5),
                            Text("${widget.servings} porciones"),
                          ],
                        ),
                    ],
                  ),

                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.prepTime != 0)
                        Row(
                          children: [
                            const Icon(Icons.timer),
                            const SizedBox(width: 5),
                            Text("${widget.prepTime} min"),
                          ],
                        ),
                      if (widget.kcal != 0)
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department),
                            const SizedBox(width: 5),
                            Text("${widget.kcal} kcal"),
                          ],
                        ),
                      if (widget.difficulty.isNotEmpty)
                        Row(
                          children: [
                            const Icon(Icons.bar_chart),
                            const SizedBox(width: 5),
                            Text(widget.difficulty),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(222, 146, 176, 172),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.local_dining, size: 14),
                        ),
                        Text(
                          "Ingredientes",
                          style: AppWidget.lightfeildtextstyle().copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...ingredients.asMap().entries.map((entry) {
                    final index = entry.key;
                    final ing = entry.value;

                    final name = ing['name'] ?? '';
                    final quantity = ing['quantity'] ?? '';
                    final image = ing['image'] ?? '';

                    return CheckboxListTile( // añade CheckboxListTile para mostrar cada ingrediente con un checkbox
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: checkedIngredients[index],
                      onChanged: (value) {
                        setState(() {
                          checkedIngredients[index] = value ?? false;
                        });
                      },
                      secondary: Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: image.isNotEmpty
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image_not_supported),
                              )
                            : const Icon(Icons.image_not_supported),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                decoration: checkedIngredients[index]
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: checkedIngredients[index]
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            quantity,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(222, 146, 176, 172),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.menu_book, size: 14),
                        ),
                        Text(
                          "Instrucciones",
                          style: AppWidget.lightfeildtextstyle().copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...steps.map((stepGroup) {
                    final stepsList = stepGroup['steps'] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...stepsList.asMap().entries.map((entry) {
                          final index = entry.key;
                          final step = entry.value ?? '';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text("${index + 1}. $step"),
                          );
                        }),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
