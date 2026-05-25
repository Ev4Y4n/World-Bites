import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile/public_profile.dart';
import 'package:flutter_application_1/screens/recipe.dart';
import 'package:flutter_application_1/screens/ui_elements/chatbot_button.dart';
import 'package:flutter_application_1/screens/ui_elements/favorite_button.dart';
import 'package:flutter_application_1/services/database.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final DatabaseService db = DatabaseService();
  final String userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: const ChatbotButton(),
              ),
              const SizedBox(height: 10),
              const Text(
                "Descubre las recetas\nde otros usuarios",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: db.getAllUserRecipes(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final recipes = snapshot.data!.docs;

                    if (recipes.isEmpty) {
                      return const Center(
                        child: Text("Todavía no has subido recetas"),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.68,
                          ),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        return recipeCard(recipes[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget recipeCard(QueryDocumentSnapshot<Map<String, dynamic>> recipeDoc) {
    final data = recipeDoc.data();

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        FirebaseFirestore.instance
            .collection('countries')
            .doc(
              data['country'],
            ) // filta las recetas de usuario por su categoría para mostrar la bandera del país
            .get(),
        FirebaseFirestore.instance
            .collection('Users')
            .doc(data['userId'])
            .get(),
      ]),

      builder: (context, snapshot) {
        String flag = '';
        String userName = 'Usuario';
        String userProfileImage = '';

        if (snapshot.hasData) {
          final countryDoc = snapshot.data![0] as DocumentSnapshot;
          final userDoc = snapshot.data![1] as DocumentSnapshot;

          print("categoryId receta: ${data['categoryId']}");

          if (countryDoc.exists) {
            final countryData = countryDoc.data() as Map<String, dynamic>;
            flag = countryData['flag'] ?? '';
          }

          if (userDoc.exists) {
            final userData = userDoc.data() as Map<String, dynamic>;

            userName = userData['userName'] ?? 'Usuario';
            userProfileImage = userData['profileImage'] ?? '';
          }
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Recipe(
                  foodname: data['name'] ?? '',
                  image: data['image'] ?? '',
                  ingredients: data['ingredients'] ?? {},
                  steps: data['steps'] ?? {},
                  difficulty: data['difficulty'] ?? '',
                  kcal: data['kcal'] ?? 0,
                  prepTime: data['prepTime'] ?? 0,
                  servings: data['servings'] ?? 0,
                  tags: const [],
                  doc: recipeDoc,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: Image.network(
                        data['image'] ?? '',
                        height: 125,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: FavoriteButton(recipeId: recipeDoc.id, size: 20),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          if (flag.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                flag,
                                width: 24,
                                height: 18,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.flag,
                                    size: 18,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              data['difficulty'] ?? '',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PublicProfile(userId: data['userId']),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: userProfileImage.isNotEmpty
                                  ? NetworkImage(userProfileImage)
                                  : null,
                              child: userProfileImage.isEmpty
                                  ? const Icon(Icons.person, size: 18)
                                  : null,
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                userName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
