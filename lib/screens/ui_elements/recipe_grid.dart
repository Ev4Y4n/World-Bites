import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/recipe.dart';
import 'favorite_button.dart';

//Clase que muestra las recetas en formato grid, usada en SavedRecipes y MyRecipes
class RecipeGrid extends StatelessWidget {
  final List recipesDocs;

  const RecipeGrid({
    super.key,
    required this.recipesDocs,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(right: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: recipesDocs.length,
      itemBuilder: (context, index) {
        var doc = recipesDocs[index];
        var recipe = doc.data() as Map<String, dynamic>;
        var prepTime = recipe['prepTime'];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Recipe(
                  foodname: recipe['name'] ?? '',
                  difficulty: recipe['difficulty'] ?? 'Desconocida',
                  image: recipe['image'] ?? 'https://via.placeholder.com/150',
                  ingredients: recipe['ingredients'] ?? [],
                  steps: recipe['steps'],
                  kcal: recipe['kcal'] ?? 0,
                  prepTime: recipe['prepTime'] ?? 0,
                  servings: recipe['servings'] ?? 0,
                  tags: recipe['tags'] ?? [],
                  doc: doc,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black12,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      Image.network(
                        recipe['image'] ?? 'https://via.placeholder.com/150',
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      FavoriteButton(recipeId: doc.id),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          recipe['name'] ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(136, 104, 92, 92),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule,
                              color: Colors.yellow, size: 14),
                          SizedBox(width: 4),
                          Text(
                            prepTime <= 60
                                ? "$prepTime min"
                                : "${(prepTime / 60).toStringAsFixed(1)} hr",
                            style:
                                TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 100,
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: (recipe['tags'] as List<dynamic>).map((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(222, 146, 176, 172),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}