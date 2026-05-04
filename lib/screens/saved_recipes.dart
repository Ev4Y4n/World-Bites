import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedRecipes extends StatefulWidget {
  const SavedRecipes({super.key});

  @override
  State<SavedRecipes> createState() => _SavedRecipesState();
}

class _SavedRecipesState extends State<SavedRecipes> {
  Stream? recipeStream;
  int selectedTab = 0;

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Future<void> getOnTheLoad() async {
    recipeStream = FirebaseFirestore.instance
        .collectionGroup("recipes")
        .where('favorite', isEqualTo: true)
        .snapshots();
    setState(() {});
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Image.asset(
                'assets/images/fondo_titulo_v2.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 230,
            right: 0,
            child: SafeArea(
              top: false,
              child: Image.asset(
                'assets/images/tenedor_1.png',
                width: 180,
                height: 180,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 180)),
          Container(
            padding: const EdgeInsets.only(top: 250),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTab == 0
                        ? const Color.fromARGB(255, 42, 79, 114)
                        : const Color.fromARGB(255, 203, 212, 221),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedTab = 0;
                    });
                  },
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
                  onPressed: () {
                    setState(() {
                      selectedTab = 1;
                    });
                  },
                  child: const Text(
                    'MIS RECETAS',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 320),
              child: selectedTab == 0
                  ? Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 400,
                          child: allRecipe(), // Muestra las recetas favoritas
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          "MIS RECETAS",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget allRecipe() {
    // Agrega esta función para mostrar las recetas favoritas
    return StreamBuilder(
      stream: recipeStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar datos"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Aun no tienes recetas guardadas'));
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index]; // Obtiene los datos de cada receta
            return recipesCard(ds['name'], ds['categoryId'], ds['image'], ds['favorite']);
          },
        );
      },
    );
  }

  Widget recipesCard(String name, String category, String imageUrl, bool  isFavorite) {
    return Card(
      child: Column(
        children: [
          Stack(
            children: [
              delete(name, isFavorite),
              Image.network(
                imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ),
          ListTile(title: Text(name), subtitle: Text(category)),
        ],
      ),
    );
  }

  Positioned delete(String name, bool  isFavorite) {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: () async{
            await FirebaseFirestore.instance
                .collectionGroup("recipes")
                .where('name', isEqualTo: name)
                .get()
                .then((querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    doc.reference.update({'favorite': false});
                  });
                });
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
                color: (isFavorite)
                    ? Color.fromARGB(255, 178, 0, 0)
                    : Colors.grey,
              ),
            ),
          ),
      ),
    );
  }
}
