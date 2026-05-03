import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/comming_soon.dart';
import 'package:flutter_application_1/screens/recipe.dart';
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

  var queryResultSet = [];
  var tempSearchStore = [];

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Future<void> getOnTheLoad() async {
    recipeStream = FirebaseFirestore.instance
        .collection("categories_italy")
        .snapshots();
    setState(() {});
  }

  void initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        search = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    setState(() {
      search = true;
    });

    var capitalizedValue = value[0].toUpperCase() + value.substring(1);

    if (queryResultSet.isEmpty && value.length == 1) {
      FirebaseFirestore.instance.collection("categories_italy").get().then((
        QuerySnapshot docs,
      ) {
        for (var doc in docs.docs) {
          var data = doc.data()! as Map<String, dynamic>;

          data.forEach((subCatName, subCatData) {
            if (subCatData is Map<String, dynamic> &&
                subCatData.containsKey('recipes')) {
              var recipesMap = subCatData['recipes'] as Map<String, dynamic>;

              recipesMap.forEach((recipeName, recipeData) {
                queryResultSet.add({
                  'name': recipeData['name'] ?? recipeName,
                  'difficulty': recipeData['difficulty'] ?? 'Desconocida',
                  'favorite': recipeData['favorite'] ?? false,
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
          return SizedBox(
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

              String name = ds['name'];
              String icon = ds['icon'];

              bool isSelected = selectedSubCategory == ds.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSubCategory = ds.id;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          icon,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            width: 120,
                            color: Colors.grey,
                            child: Icon(Icons.image),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        name,
                        style: AppWidget.lightfeildtextstyle()?.copyWith(
                          color: isSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
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
          return Center(child: CircularProgressIndicator());
        }

        var recipesDocs = snapshot.data.docs;

        if (recipesDocs.isEmpty) {
          return Center(child: Text("No hay recetas"));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(right: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: recipesDocs.length,
          itemBuilder: (context, index) {
            var doc = recipesDocs[index];
            var recipe = doc.data() as Map<String, dynamic>;
            var prepTime = recipe['prepTime'];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Recipe(
                      foodname: recipe['name'] ?? '',
                      difficulty: recipe['difficulty'] ?? 'Desconocida',
                      isFavorite: recipe['favorite'] ?? false,
                      image:
                          recipe['image'] ?? 'https://via.placeholder.com/150',
                      ingredients: recipe['ingredients'] ?? [],
                      steps: recipe['steps'],
                      kcal: recipe['kcal'] ?? 0,
                      prepTime: recipe['prepTime'] ?? 0,
                      servings: recipe['servings'] ?? 0,
                      tags: recipe['tags'] ?? [],
                      doc: doc,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image.network(
                            recipe['image'] ??
                                'https://via.placeholder.com/150',
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () async {
                                await doc.reference.update({
                                  'favorite': !(recipe['favorite'] ?? false),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Actualizado favorito: ${recipe['name'] ?? 'Receta'}",
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(137, 255, 255, 255),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.favorite,
                                    size: 16,
                                    color: (recipe['favorite'] == true)
                                        ? Color.fromARGB(255, 178, 0, 0)
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              recipe['name'] ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(136, 104, 92, 92),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                prepTime <= 60
                                    ? "$prepTime min"
                                    : "${(prepTime / 60).toStringAsFixed(1)} hr",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 100,
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: (recipe['tags'] as List<dynamic>).map((tag) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(222, 146, 176, 172),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
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
              isFavorite: data['favorite'],
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(136, 97, 87, 87),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            commingSoon();
                          },
                          icon: Icon(
                            Icons.mark_chat_unread_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
