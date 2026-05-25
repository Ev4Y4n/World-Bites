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

    final categoryRef = FirebaseFirestore.instance
        .collection('categories_mexico')
        .doc(categoryId);

    await categoryRef.set({
      'name': category['name'],
      'icon': category['icon'],
      'index': category['index'],
    }, SetOptions(merge: true));
  }

  print("Categorías subidas");
}

Future<void> subirRecetas(String assetPath) async {
  final jsonString = await rootBundle.loadString(assetPath);
  final data = jsonDecode(jsonString);

  final List categories = data['categories'];

  for (var category in categories) {
    final String categoryId = category['id'];
    final List recipes = category['recipes'] ?? [];

    final categoryRef = FirebaseFirestore.instance
        .collection('categories_mexico')
        .doc(categoryId);

    for (var recipe in recipes) {
      final String recipeId = recipe['id'];

      await categoryRef.collection('recipes').doc(recipeId).set({
        'categoryId': categoryId,

        // 🔥 datos completos
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
 
Future<void> subirPais(String assetPath) async {
  try {
    final jsonString = await rootBundle.loadString(assetPath);
    final data = jsonDecode(jsonString);
 
    final String country = data['country'];
    final List categories = data['categories'];
 
    print("Subiendo categorías de $country");
 
    for (var category in categories) {
      final String categoryId = category['id'];
      final List recipes = category['recipes'] ?? [];
 
      final categoryRef = FirebaseFirestore.instance
          .collection('categories_mexico')
          .doc(categoryId);
 
      await categoryRef.set({
        'name': category['name'] ?? '',
        'icon': category['icon'] ?? '',
      });
 
      await categoryRef.update({'id': FieldValue.delete()});
 
      for (var recipe in recipes) {
        final String recipeId = recipe['id'];
        await categoryRef
            .collection('recipes')
            .doc(recipeId)
            .set({
          'name': recipe['name'] ?? '',
        });
      }
 
      print("Categoría $categoryId subida con ${recipes.length} recetas");
    }

    print("Recetas subidas: $categoryId");
  }
}
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
  print("Inicializando Firebase...");
 
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 
  print("Firebase listo");

  await subirCategorias('assets/json/categorias_mexico.json');
  await subirRecetas('assets/json/recetas_mexico.json');

  print("TODO TERMINADO");

  await Future.delayed(const Duration(seconds: 5));
 
  //  test rápido (puedes borrarlo luego)
  await FirebaseFirestore.instance.collection('test').doc('conexion').set({
    'ok': true,
  });
 
  print("Test Firestore OK");
 
  //  subir JSON
  await subirPais('assets/json/categorias_mexico.json');
 
  print("TODO TERMINADO!");
 
  //  evitar que se cierre antes
  await Future.delayed(const Duration(seconds: 10));
}