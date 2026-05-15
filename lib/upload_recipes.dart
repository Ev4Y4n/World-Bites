import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';

Future<void> subirCategorias(String assetPath) async {
  final jsonString = await rootBundle.loadString(assetPath);
  final data = jsonDecode(jsonString);

  final List categories = data['categories'];

  for (var category in categories) {
    final String categoryId = category['id'];
    final List recipes = category['recipes'] ?? [];

    final categoryRef = FirebaseFirestore.instance
        .collection('categories_mexico')
        .doc(categoryId);

    await categoryRef.set({
      'name': category['name'],
      'icon': category['icon'],
      'index': category['index'],
    });

    for (var recipe in recipes) {
      await categoryRef.collection('recipes').doc(recipe['id']).set({
        'name': recipe['name'] ?? '',
        'icon': recipe['icon'] ?? '',
      }, SetOptions(merge: true));
    }

    print("Categoría subida: $categoryId");
  }
}

Future<void> subirRecetas(String assetPath) async {
  final jsonString = await rootBundle.loadString(assetPath);
  final data = jsonDecode(jsonString);

  final List categories = data['categories'];

  for (var category in categories) {
    final String categoryId = category['id'];
    final List recipes = category['recipes'];

    for (var recipe in recipes) {
      final String recipeId = recipe['id'];

      await FirebaseFirestore.instance
          .collection('categories_mexico')
          .doc(categoryId)
          .collection('recipes')
          .doc(recipeId)
          .set({
            'name': recipe['name'] ?? '',
            'image': recipe['image'] ?? '',
            'difficulty': recipe['difficulty'] ?? '',
            'kcal': recipe['kcal'] ?? 0,
            'prepTime': recipe['prepTime'] ?? 0,
            'servings': recipe['servings'] ?? 0,
            'tags': recipe['tags'] ?? [],
            'ingredients': recipe['ingredients'] ?? [],
            'steps': recipe['steps'] ?? [],
          }, SetOptions(merge: true));

      print("Receta subida: $recipeId");
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Firebase listo");

  await subirCategorias('assets/json/categorias_mexico.json');

  await subirRecetas('assets/json/recetas_mexico.json');

  print("TODO TERMINADO");

  await Future.delayed(const Duration(seconds: 5));
}
