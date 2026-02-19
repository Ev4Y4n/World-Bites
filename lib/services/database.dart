
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future Addrecipe(Map<String, dynamic> addrecipe)async{
    return await FirebaseFirestore.instance.collection("Recipe").add(addrecipe);
  }

  Future<Stream<QuerySnapshot>> getAllRecipes()async{
    return await FirebaseFirestore.instance.collection("Recipe").snapshots();
  }

  Future<Stream<QuerySnapshot>> getRecipeCategory(String category)async{
    return await FirebaseFirestore.instance.collection("Recipe").where("Category", isEqualTo: category).snapshots();
  }
}