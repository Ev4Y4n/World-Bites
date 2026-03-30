import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  //Agrega una nueva receta a la colección "Recipe" en Firebase
  Future addRecipe(Map<String, dynamic> addrecipe) async {
    return await FirebaseFirestore.instance.collection("Recipe").add(addrecipe);
  }

  //Obtiene un stream de datos en tiempo real de todas las recetas
  Stream<QuerySnapshot> getAllRecipes() {
    return FirebaseFirestore.instance
        .collection("categories_italy")
        .snapshots();
  }

  //Obtiene un stream de datos en tiempo real de las recetas filtradas por categoría
  Stream<QuerySnapshot> getRecipeCategory(String category) {
    return FirebaseFirestore.instance
        .collection("categories_italy")
        .doc(category)
        .collection("recipes")
        .snapshots();
  }

  //Obtiene un stream de datos en tiempo real de las recetas filtradas por nombre (búsqueda)
  Future<QuerySnapshot> search(String name) async {
    return await FirebaseFirestore.instance
        .collection("Recipe")
        .where("Key", isEqualTo: name.substring(0, 1).toUpperCase())
        .get();
  }
}
