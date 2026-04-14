import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';

Future<void> subirPais(String assetPath) async {
  try {
    print("Leyendo JSON...");

    final jsonString = await rootBundle.loadString(assetPath);
    final data = jsonDecode(jsonString);

    final String country = data['country'];
    final List categories = data['categories'];

    // evita crash si no existe
    final List<String> recommended = List<String>.from(
      data['recommended'] ?? [],
    );

    print("Subiendo país: $country");

    for (var category in categories) {
      final String categoryId = category['id'];
      final String categoryName = category['name'];
      final String categoryImage = category['image'];

      final List recipes = category['recipes'];

      for (var recipe in recipes) {
        final String recipeId = recipe['id'];

        print("Subiendo receta: $recipeId");

        await FirebaseFirestore.instance
            .collection('recipes')
            .doc(recipeId)
            .set({
              'id': recipeId,
              'name': recipe['name'],
              'image': recipe['image'],
              'favorite': recipe['favorite'] ?? false,

              // relación
              'categoryId': categoryId,
              'categoryName': categoryName,
              'categoryImage': categoryImage,

              'country': country,

              // recomendado seguro
              'isRecommended': recommended.contains(recipeId),
            }, SetOptions(merge: true));
      }
    }

    print("País $country subido correctamente");
  } catch (e, stack) {
    print("ERROR: $e");
    print(stack);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Inicializando Firebase...");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Firebase listo");

  // 🧪 test rápido (puedes borrarlo luego)
  await FirebaseFirestore.instance.collection('test').doc('conexion').set({
    'ok': true,
  });

  print("Test Firestore OK");

  // 🚀 subir JSON
  await subirPais('assets/json/mexico.json');

  print("TODO TERMINADO");

  // ⏳ evitar que se cierre antes
  await Future.delayed(const Duration(seconds: 10));
}
