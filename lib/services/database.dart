import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future addRecipe(Map<String, dynamic> addrecipe) async {
    return await _db.collection("Recipe").add(addrecipe);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRecipes() {
    //return _db.collection("categories_italy").snapshots();
      return _db.collectionGroup('recipes').snapshots();

  }

  Stream<QuerySnapshot> getUserById(String userID) {
    return _db.collection("Users").where("id", isEqualTo: userID).snapshots();
  }

  Future<List<String>> getFavorites(String userID) async {
    final doc = await _db.collection('Users').doc(userID).get();
    return List<String>.from(doc.data()?['favoriteRecipes'] ?? []);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserRecipes(String userID) {
    return _db
        .collection('Recipe')
        .where('userId', isEqualTo: userID)
        .snapshots();
  }

  Future<void> deleteUserRecipe(String recipeId, {String? imageUrl}) async {
    // borrar imagen si existe
    if (imageUrl != null && imageUrl.isNotEmpty) {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    }
    // borrar receta
    await _db.collection('Recipe').doc(recipeId).delete();
  }

  // Agrega o quita una receta de favoritos del usuario
  Future<void> toggleFavorite(String userID, String recipeId) async {
    final ref = _db.collection('Users').doc(userID);

    final doc = await ref.get();
    final data = doc.data() ?? {};

    final List favs = List.from(data['favoriteRecipes'] ?? []);

    if (favs.contains(recipeId)) {
      await ref.update({
        'favoriteRecipes': FieldValue.arrayRemove([recipeId]),
      });
    } else {
      await ref.update({
        'favoriteRecipes': FieldValue.arrayUnion([recipeId]),
      });
    }
  }

  Future<List<Map<String, String>>> getCountries() async {
    final snapshot = await _db.collection('countries').get();

    return snapshot.docs.map((doc) {
      return {"id": doc.id, "name": doc.data()['name'] as String};
    }).toList();
  }

  //accede a la categoría específica dentro de la colección dinámica (categories_italy, categories_mexico...)
  Stream<QuerySnapshot> getRecipeCategory(String category) {
    return _db
        .collection("categories_italy")
        .doc(category)
        .collection("recipes")
        .snapshots();
  }

  //obtiene todas las categorias de cada pais
  Future<List<Map<String, String>>> getCategoriesByCountry(
    String countryDocId,
  ) async {
    // Busca el país seleccionado
    final countryDoc = await _db
        .collection('countries')
        .doc(countryDocId)
        .get();

    // Saca categoryID
    final String categoryId = countryDoc.data()?['categoryID'] ?? '';
    if (categoryId.isEmpty) return [];
    // Busca la colección dinámica
    final snapshot = await _db.collection(categoryId).orderBy('index').get();
    // Devuelve IDs de documentos como lista
    return snapshot.docs.map((doc) {
      return {"id": doc.id, "name": doc.data()['name'] as String};
    }).toList();
  }

  Future<QuerySnapshot> search(String name) async {
    return await _db
        .collection("Recipe")
        .where("Key", isEqualTo: name.substring(0, 1).toUpperCase())
        .get();
  }

  Future addUser(String userID, Map<String, dynamic> user) async {
    return await _db.collection("Users").doc(userID).set(user);
  }

  Future updateUserName(String userID, String newUserName) async {
    return await _db.collection("Users").doc(userID).update({
      "userName": newUserName,
    });
  }

  Future addProfilePicture(String userID, String downloadurl) async {
    return await _db.collection("Users").doc(userID).update({
      "profileImage": downloadurl,
    });
  }
}
