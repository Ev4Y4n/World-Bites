import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/recipe.dart';
import 'package:flutter_application_1/screens/ui_elements/favorite_button.dart';
import 'package:flutter_application_1/screens/ui_elements/recipe_card.dart';
import 'package:flutter_application_1/screens/ui_elements/user_recipe_card.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedRecipes extends StatefulWidget {
  final int initialTab;

  const SavedRecipes({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<SavedRecipes> createState() => _SavedRecipesState();
}

class _SavedRecipesState extends State<SavedRecipes> {
  late int selectedTab;

  /// IDs de recetas favoritas del usuario
  List<String> favouriteIds = [];

  /// Stream con TODAS las recetas del collectionGroup
  Stream<QuerySnapshot<Map<String, dynamic>>>? recipeStream;

  bool loadingFavs = true;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab;
    loadFavorites();
  }

  /// Carga los IDs favoritos del usuario y prepara el stream de recetas
  Future<void> loadFavorites() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      favouriteIds = await DatabaseService().getFavorites(uid);
      recipeStream = DatabaseService().getAllRecipes();
    }

    loadingFavs = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 110,
        title: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Recetas\n',
                  style: GoogleFonts.barlow(fontSize: 35, color: Colors.white),
                ),
                TextSpan(
                  text: 'Guardadas',
                  style: GoogleFonts.barlow(fontSize: 30, color: Colors.white),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,

      body: Column(
        children: [
          // Cabecera con imagen de fondo
          Stack(
            children: [
              Image.asset(
                'assets/images/fondo_titulo_v2.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 50,
                left: 230,
                right: 0,
                child: Image.asset(
                  'assets/images/tenedor_1.png',
                  width: 180,
                  height: 180,
                ),
              ),
            ],
          ),

          // Botones de pestañas
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTab == 0
                        ? const Color.fromARGB(255, 42, 79, 114)
                        : const Color.fromARGB(255, 203, 212, 221),
                  ),
                  onPressed: () => setState(() => selectedTab = 0),
                  child: const Text(
                    'FAVORITOS',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTab == 1
                        ? const Color.fromARGB(255, 42, 79, 114)
                        : const Color.fromARGB(255, 203, 212, 221),
                  ),
                  onPressed: () => setState(() => selectedTab = 1),
                  child: const Text(
                    'MIS RECETAS',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Contenido de la pestaña
          Expanded(
            child: selectedTab == 0
                ? allRecipe()
                : userRecipes(FirebaseAuth.instance.currentUser!.uid),
          ),
        ],
      ),
    );
  }

  Widget userRecipes(String uid) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: DatabaseService().getUserRecipes(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final userDocs = snapshot.data!.docs;

        if (userDocs.isEmpty) {
          return const Center(child: Text('Aún no tienes recetas creadas'));
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: userDocs.length,
          itemBuilder: (context, index) {
            return userRecipesCard(
              userDocs[index],
            ); // Tarjeta de receta del usuario
          },
        );
      },
    );
  }

  /// Muestra las recetas favoritas usando los IDs guardados
  Widget allRecipe() {
    if (loadingFavs) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recipeStream == null) {
      return const Center(child: Text('Usuario no autenticado'));
    }

    if (favouriteIds.isEmpty) {
      return const Center(child: Text('Aún no tienes recetas guardadas'));
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: recipeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allDocs = snapshot.data!.docs;

        // Filtrar solo las recetas cuyo ID está en favoriteRecipes
        final favDocs = allDocs
            .where((doc) => favouriteIds.contains(doc.id))
            .toList();

        if (favDocs.isEmpty) {
          return const Center(child: Text('Aún no tienes recetas guardadas'));
        }

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos columnas
            mainAxisSpacing: 12, // Espacio vertical entre tarjetas
            crossAxisSpacing: 12, // Espacio horizontal entre tarjetas
            childAspectRatio: 0.7, // Proporción de aspecto
          ),
          itemCount: favDocs.length,
          itemBuilder: (context, index) {
            final recipeDoc = favDocs[index];
            return recipesCard(recipeDoc);
          },
        );
      },
    );
  }

  Widget recipesCard(DocumentSnapshot<Map<String, dynamic>> ds) {
    final data = ds.data()!;

    return RecipeCard(
      doc: ds,
      recipe: data,
      onFavoriteTap: () {
        setState(() {
          loadFavorites();
        });
      },
    );
  }

  Widget userRecipesCard(DocumentSnapshot<Map<String, dynamic>> ds) {
    final data = ds.data()!;

    return UserRecipeCard(
      doc: ds,
      recipe: data,
      onDeleteTap: () {
        loadFavorites();
      },
    );
  }
}
