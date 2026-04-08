import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class Recipe extends StatefulWidget {
  final String image, foodname, difficulty;
  final List<dynamic> ingredients, steps, tags;
  final int kcal, prepTime, servings;
  bool isFavorite;
  final dynamic doc;

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
    required this.doc,
  });

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  @override
  Widget build(BuildContext context) {
    // Null-safety: asegurar listas no nulas
    final ingredients = widget.ingredients ?? [];
    final steps = widget.steps ?? [];
    final tags = widget.tags ?? [];

    return Scaffold(
      body: Container(
        child: Stack(
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
                child: Icon(Icons.image_not_supported, size: 50),
              ),
            ),
            Positioned(
              top: 40.0,
              left: 20.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(136, 97, 87, 87),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30.0),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              top: 40.0,
              right: 20.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(136, 97, 87, 87),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: widget.isFavorite
                        ? Color.fromARGB(255, 178, 0, 0)
                        : Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    if (widget.doc != null) {
                      try {
                        await widget.doc.reference.update(
                            {'favorite': !(widget.isFavorite)});
                        setState(() {
                          widget.isFavorite = !widget.isFavorite;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Actualizado favorito: ${widget.foodname} - ${widget.isFavorite ? "Agregado a favoritos" : "Eliminado de favoritos"}",
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error actualizando favorito"),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.width / 1.1),
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
                          width: 220,
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
                        if (widget.prepTime != 0)
                          Row(
                            children: [
                              Icon(Icons.timer),
                              SizedBox(width: 5.0),
                              Text("${widget.prepTime} min"),
                            ],
                          ),
                        if (widget.kcal != 0)
                          Row(
                            children: [
                              Icon(Icons.local_fire_department),
                              SizedBox(width: 5.0),
                              Text("${widget.kcal} kcal"),
                            ],
                          ),
                        if (widget.difficulty.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.bar_chart),
                              SizedBox(width: 5.0),
                              Text(widget.difficulty),
                            ],
                          ),
                      ],
                    ),
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
                            child: Icon(Icons.local_dining,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                size: 14),
                          ),
                          Text(
                            "Ingredientes",
                            style: AppWidget.lightfeildtextstyle()
                                .copyWith(fontSize: 15.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ...ingredients.map((ing) {
                      final name = ing['name'] ?? '';
                      final quantity = ing['quantity'] ?? '';
                      final image = ing['image'] ?? '';
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: image.isNotEmpty
                                    ? Image.network(
                                        image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported),
                                      )
                                    : Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              "$name",
                              style: TextStyle(fontSize: 14.0),
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          Text(
                            "$quantity",
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      );
                    }),
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
                            child: Icon(Icons.menu_book,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                size: 14),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Instrucciones",
                            style: AppWidget.lightfeildtextstyle()
                                .copyWith(fontSize: 15.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ...steps.map((stepGroup) {
                      final tag = stepGroup['tag'] ?? '';
                      final stepsList = stepGroup['steps'] ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tag.isNotEmpty)
                            ...stepsList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final step = entry.value ?? '';
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text("${index + 1}. $step"),
                              );
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