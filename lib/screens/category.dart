import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/recipe.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class Category extends StatefulWidget {
  final String country;   // NUEVO
  final String category;  // ya existente

  const Category({
    super.key,
    required this.country,
    required this.category,
  });

  @override
  State<Category> createState() => _Category();
}

class _Category extends State<Category> {
  Stream? categoryStream;

  Future<void> getOnTheLoad() async {
    categoryStream = DatabaseService().getRecipeCategory(
      widget.country,
      widget.category,
    );
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allRecipe() {
    return StreamBuilder(
      stream: categoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Recipe(
                            foodname: ds["name"],
                            image: ds["icon"],
                            ingredients: ds["ingredients"],
                            steps: ds["steps"],
                            difficulty: ds["difficulty"],
                            kcal: ds["kcal"],
                            prepTime: ds["prepTime"],
                            servings: ds["servings"],
                            tags: ds["tags"],
                            doc: ds,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            ds["image"],
                            height: 150,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          ds["name"],
                          style: AppWidget.lightfeildtextstyle(),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                widget.category,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(child: allRecipe()),
          ],
        ),
      ),
    );
  }
}