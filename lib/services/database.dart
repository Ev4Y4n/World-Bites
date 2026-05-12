import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future addRecipe(Map<String, dynamic> addrecipe) async {
    return await _db.collection("Recipe").add(addrecipe);
  }

  Stream<QuerySnapshot> getAllRecipes() {
    return _db.collection("categories_italy").snapshots();
  }

  Stream<QuerySnapshot> getUserById(String uid) {
    return _db.collection("Users").where("id", isEqualTo: uid).snapshots();
  }

  Future<List<String>> getFavorites(String uid) async {
    final doc = await _db.collection('Users').doc(uid).get();
    return List<String>.from(doc.data()?['favoriteRecipes'] ?? []);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserRecipes(String uid) {
    return _db.collection('Recipe').where('userId', isEqualTo: uid).snapshots();
  }

  // Agrega o quita una receta de favoritos del usuario
  Future<void> toggleFavorite(String uid, String recipeId) async {
    final ref = _db.collection('Users').doc(uid);

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
  Future<List<Map<String, String>>> getCategoriesByCountry(String countryDocId,) async {
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

  Future addUser(String uid, Map<String, dynamic> user) async {
    return await _db.collection("Users").doc(uid).set(user);
  }

  Future updateUserName(String uid, String newUserName) async {
    return await _db.collection("Users").doc(uid).update({
      "userName": newUserName,
    });
  }

  Future addProfilePicture(String uid, String downloadurl) async {
    return await _db.collection("Users").doc(uid).update({
      "profileImage": downloadurl,
    });
  }
}
