import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/recipe.dart';
import 'package:flutter_application_1/screens/ui_elements/delete_button.dart';
import 'package:flutter_application_1/screens/ui_elements/favorite_button.dart';

class UserRecipeCard extends StatelessWidget {
  final DocumentSnapshot doc;
  final Map<String, dynamic> recipe;
  final VoidCallback onDeleteTap;

  const UserRecipeCard({
    super.key,
    required this.doc,
    required this.recipe,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final prepTime = recipe['prepTime'] ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recipe(
              foodname: recipe['name'] ?? '',
              difficulty: recipe['difficulty'] ?? 'Desconocida',
              image: recipe['image'] ?? '',
              ingredients: recipe['ingredients'] ?? [],
              steps: recipe['steps'],
              kcal: recipe['kcal'] ?? 0,
              prepTime: prepTime,
              servings: recipe['servings'] ?? 0,
              tags: recipe['tags'] ?? [],
              doc: doc,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black12,
              offset: Offset(0, 3),
            ),
          ],
        ),   
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼 IMAGE + FAVORITO
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image.network(
                    recipe['image'] ?? '',
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  DeleteButton(recipeId: doc.id, imageUrl: recipe['image']),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🍝 NAME + TIME
            Row(
              children: [
                Expanded(
                  child: Text(
                    recipe['name'] ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(136, 104, 92, 92),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        prepTime <= 60
                            ? "$prepTime min"
                            : "${(prepTime / 60).toStringAsFixed(1)} hr",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // 🏷 TAGS
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: (recipe['tags'] as List<dynamic>? ?? []).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(222, 146, 176, 172),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag.toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}