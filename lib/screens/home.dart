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
  Stream?
  recipeStream; // Agrega esta variable para almacenar el stream de recetas
  bool search = false;
  String? selectedSubCategory;

  List<String> favouriteRecipes = [];

  var queryResultSet = [];
  var tempSearchStore = [];

  @override
  void initState() {
    getOnTheLoad();
    createUserIfNotExists();
    super.initState();
  }

  Future<void> getOnTheLoad() async {
    recipeStream = FirebaseFirestore.instance
        .collection("categories_italy")
        .snapshots();
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

  void initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        search = false;
        queryResultSet = []; // Limpia los resultados anteriores
        tempSearchStore = []; // Limpia los resultados temporales anteriores
      });
      return;
    }

    setState(() {
      search = true;
    });

    var capitalizedValue = value[0].toUpperCase() + value.substring(1);

    if (queryResultSet.isEmpty && value.length == 1) {
      // Solo realiza la consulta a Firestore la primera vez que se ingresa un carácter
      FirebaseFirestore.instance.collection("categories_italy").get().then((
        QuerySnapshot docs,
      ) {
        for (var doc in docs.docs) {
          var data = doc.data()! as Map<String, dynamic>;

          data.forEach((subCatName, subCatData) {
            // Itera sobre cada subcategoría
            if (subCatData is Map<String, dynamic> &&
                subCatData.containsKey('recipes')) {
              var recipesMap = subCatData['recipes'] as Map<String, dynamic>;

              recipesMap.forEach((recipeName, recipeData) {
                queryResultSet.add({
                  'name': recipeData['name'] ?? recipeName,
                  'difficulty': recipeData['difficulty'] ?? 'Desconocida',
                  'image':
                      recipeData['image'] ?? 'https://via.placeholder.com/150',
                  'ingredients': recipeData['ingredients'] ?? [],
                  'kcal': recipeData['kcal'] ?? 0,
                  'steps': recipeData['steps'] ?? [],
                  'prepTime': recipeData['prepTime'] ?? 0,
                  'servings': recipeData['servings'] ?? 0,
                  'tags': recipeData['tags'] ?? [],
                });
              });
            }
          });
        }

        filterSearch(capitalizedValue);
      });
    } else {
      filterSearch(capitalizedValue);
    }
  }

  void filterSearch(String capitalizedValue) {
    tempSearchStore = [];

    for (var element in queryResultSet) {
      if ((element["name"] as String).startsWith(capitalizedValue)) {
        tempSearchStore.add(element);
      }
    }

    setState(() {});
  }

  void commingSoon() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const CommingSoon()));
  }

  Widget categoryList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("categories_italy")
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        var docs = snapshot.data.docs;

        if (selectedSubCategory == null && docs.isNotEmpty) {
          selectedSubCategory = docs[0].id;
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var ds = docs[index];

              return CategoryItem(
                name: ds['name'],
                icon: ds['icon'],
                isSelected: selectedSubCategory == ds.id,
                onTap: () {
                  setState(() {
                    selectedSubCategory = ds.id;
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget allRecipe() {
    if (selectedSubCategory == null) return Container();

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('categories_italy')
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
    // Muestra los resultados de búsqueda
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
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    data['image'] ?? 'https://via.placeholder.com/70',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                Text(data['name'] ?? '', style: AppWidget.boldfieldtextstyle()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 60, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(136, 97, 87, 87),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          context.read<AppState>().selectCountry(null);
                        },
                      ),
                    ),
                    const SizedBox(width: 260),
                    const ChatbotButton(),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    Text(
                      "Descubre recetas\nde cada rincón",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.only(right: 20, bottom: 20),
                child: TextField(
                  onChanged: (value) => initiateSearch(value),
                  decoration: InputDecoration(
                    hintText: "Buscar receta ...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              search
                  ? ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: tempSearchStore
                          .map((e) => buildResultCard(e))
                          .toList(),
                    )
                  : categoryList(),

              SizedBox(height: 20),

              search
                  ? Container()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: allRecipe(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
