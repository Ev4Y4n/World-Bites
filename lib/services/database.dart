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

  //Obtiene un stream de datos en tiempo real de un usuario específico por su ID
  Stream<QuerySnapshot> getUserById(String uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .where("id", isEqualTo: uid)
        .snapshots();
  }

  //Agrega un nuevo usuario a la colección "Users" en Firebase
  Future addUser(String uid, Map<String, dynamic> user) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .set(user);
  }

  //Actualiza el nombre de usuario de un usuario específico en la colección "Users" en Firebase
  Future updateUserName(String uid,  String newUserName) async {
    return await FirebaseFirestore.instance.collection("Users").doc(uid).update(
      {"userName": newUserName},
    );
  }

  //Agrega la URL de la foto de perfil a la colección "Users" en Firebase para un usuario específico
  Future addProfilePicture(String uid, String downloadurl) async {
    return await FirebaseFirestore.instance.collection("Users").doc(uid).update({"profileImage": downloadurl});
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
