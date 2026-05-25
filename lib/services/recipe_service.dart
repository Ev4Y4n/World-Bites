import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene todas las categorías (Italia en tu caso)
  Stream<QuerySnapshot> getCategories() {
    return _db.collection("categories_italy").snapshots();
  }

  /// Obtiene las recetas de una subcategoría
  Stream<QuerySnapshot> getRecipes(String subCategoryId) {
    return _db
        .collection("categories_italy")
        .doc(subCategoryId)
        .collection("recipes")
        .snapshots();
  }
  
  Future<void> createUserIfNotExists() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        'favouriteRecipes': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
