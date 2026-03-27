
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future Addrecipe(Map<String, dynamic> addrecipe)async{
    return await FirebaseFirestore.instance.collection("Recipe").add(addrecipe);
  }

  Future<Stream<QuerySnapshot>> getAllRecipes()async{
    return FirebaseFirestore.instance.collection("categories_italy").snapshots();
  }

  Future<Stream<QuerySnapshot>> getRecipeCategory(String category)async{
    return FirebaseFirestore.instance.collection("Recipe").where("Category", isEqualTo: category).snapshots();
  }

  Future<QuerySnapshot> Search(String name)async{
    return await FirebaseFirestore.instance.collection("Recipe").where("Key", isEqualTo: name.substring(0,1).toUpperCase()).get();
  }
}