import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:world_bites/firebase_options.dart';

Future<void> subirPais(String path) async {
  final file = File(path);
  final data = jsonDecode(await file.readAsString());

  final country = data['country'];
  final categories = data['categories'];
  final recommended = data['recommended'];

  for (var category in categories) {
    final categoryId = category['id'];
    final categoryName = category['name'];
    final categoryIcon = category['icon'];
    final recipes = category['recipes'];

    for (var recipe in recipes) {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipe['id'])
          .set({
            'id': recipe['id'],
            'name': recipe['name'],
            'image': recipe['image'],
            'favorite': recipe['favorite'],
            'categoryId': categoryId,
            'categoryName': categoryName,
            'categoryIcon': categoryIcon,
            'country': country,
            'isRecommended': recommended.contains(recipe['id']),
          }, SetOptions(merge: true));
    }
  }

  print('País $country subido');
}

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await subirPais('mexico.json');

  print('Todo subido');
}
