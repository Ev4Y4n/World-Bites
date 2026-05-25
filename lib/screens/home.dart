import 'dart:async'; // Necesario para el Timer (Debounce)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/comming_soon.dart';
import 'package:flutter_application_1/screens/recipe.dart';
import 'package:flutter_application_1/screens/ui_elements/category_item.dart';
import 'package:flutter_application_1/screens/ui_elements/chatbot_button.dart';
import 'package:flutter_application_1/screens/ui_elements/recipe_card.dart';
import 'package:flutter_application_1/screens/ui_elements/recipe_grid.dart';
import 'package:flutter_application_1/widget/support_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/app_state.dart';

class MainScreen extends StatefulWidget {
  final String categoryID;
  const MainScreen({super.key, required this.categoryID});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  Stream? recipeStream;
  bool search = false;
  String? selectedSubCategory;
  List<String> favouriteRecipes = [];

  // Variables para la lógica de búsqueda fluida
  List<Map<String, dynamic>> allRecipesForSearch = [];
  List<Map<String, dynamic>> tempSearchStore = [];
  Timer? _debounce; // Controla el retraso al escribir

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
    createUserIfNotExists();
    _preloadSearchData();
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Limpiamos el timer para evitar errores de memoria
    super.dispose();
  }

  Future<void> getOnTheLoad() async {
  // Coge el primer documento de la colección del país
  final snapshot = await FirebaseFirestore.instance
      .collection(widget.categoryID)
      .orderBy('index') // si tienes campo index, si no quítalo
      .limit(1)
      .get();

  if (snapshot.docs.isNotEmpty) {
    selectedSubCategory = snapshot.docs.first.id;
  }

  setState(() {});
}

  Future<void> createUserIfNotExists() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('Users').doc(uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        'favouriteRecipes': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Pre-carga los datos en segundo plano
  Future<void> _preloadSearchData() async {
    try {
      var categoryDocs = await FirebaseFirestore.instance
          .collection(widget.categoryID)
          .get();
      List<Map<String, dynamic>> tempList = [];

      for (var doc in categoryDocs.docs) {
        var recipeDocs = await doc.reference.collection('recipes').get();
        for (var recipe in recipeDocs.docs) {
          var data = recipe.data();
          tempList.add({
            'name': data['name'] ?? 'Sin nombre',
            'difficulty': data['difficulty'] ?? 'Desconocida',
            'image': data['image'] ?? '',
            'ingredients': data['ingredients'] ?? [],
            'kcal': data['kcal'] ?? 0,
            'steps': data['steps'] ?? [],
            'prepTime': data['prepTime'] ?? 0,
            'servings': data['servings'] ?? 0,
            'tags': data['tags'] ?? [],
          });
        }
      }
      if (mounted) {
        setState(() {
          allRecipesForSearch = tempList;
        });
      }
    } catch (e) {
      debugPrint("Error precargando búsqueda: $e");
    }
  }

  // Lógica de búsqueda con Debounce para evitar el "pete" (Jank)
  void initiateSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (value.isEmpty) {
        setState(() {
          search = false;
          tempSearchStore = [];
        });
        return;
      }

      setState(() {
        search = true;
        tempSearchStore = allRecipesForSearch.where((recipe) {
          final name = recipe['name'].toString().toLowerCase();
          return name.contains(value.toLowerCase());
        }).toList();
      });
    });
  }

  Widget categoryList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // 👈 SOLO ESTO
      child: SizedBox(
        height: 180,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(widget.categoryID)
              .orderBy('index') 
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var docs = snapshot.data.docs;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var ds = docs[index];

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                  ), // 👈 separación entre cards
                  child: CategoryItem(
                    name: ds['name'],
                    icon: ds['icon'],
                    isSelected: selectedSubCategory == ds.id,
                    onTap: () {
                      setState(() {
                        selectedSubCategory = ds.id;
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget allRecipe() {
    if (selectedSubCategory == null) return Container();

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(widget.categoryID)
          .doc(selectedSubCategory)
          .collection('recipes')
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var recipesDocs = snapshot.data.docs;
        if (recipesDocs.isEmpty) {
          return const Center(child: Text("No hay recetas"));
        }

        return RecipeGrid(recipesDocs: recipesDocs);
      },
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recipe(
              foodname: data['name'],
              image: data['image'],
              ingredients: data['ingredients'],
              steps: data['steps'],
              difficulty: data['difficulty'],
              kcal: data['kcal'],
              prepTime: data['prepTime'],
              servings: data['servings'],
              tags: data['tags'],
              doc: null,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: data['image'] != ''
                      ? Image.network(
                          data['image'],
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              const Icon(Icons.fastfood, size: 40),
                        )
                      : const Icon(Icons.fastfood, size: 70),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    data['name'] ?? '',
                    style: AppWidget.boldfieldtextstyle(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(136, 97, 87, 87),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          context.read<AppState>().selectCountry(null);
                        },
                      ),
                    ),
                    const ChatbotButton(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Descubre recetas\nde cada rincón",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (value) => initiateSearch(value),
                  decoration: InputDecoration(
                    hintText: "Buscar receta ...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              search
                  ? (tempSearchStore.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Sin resultados"),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tempSearchStore.length,
                            itemBuilder: (context, index) =>
                                buildResultCard(tempSearchStore[index]),
                          ))
                  : Column(
                      children: [
                        categoryList(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: allRecipe(),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
