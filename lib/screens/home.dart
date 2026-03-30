import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/recipe.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  Stream? recipeStream;
  bool search = false;
  String? selectedSubCategory; // para almacenar la subcategoría seleccionada

  var queryResultSet = [];
  var tempSearchStore = [];

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Future<void> getOnTheLoad() async {
    // cargar recetas al inicio
    recipeStream = FirebaseFirestore.instance
        .collection("categories_italy")
        .snapshots();
    setState(() {});
  }

  void initiateSearch(String value) {
    // función de búsqueda
    if (value.isEmpty) {
      setState(() {
        search = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    setState(() {
      // activar modo búsqueda
      search = true;
    });

    var capitalizedValue =
        value[0].toUpperCase() +
        value.substring(1); // capitalizar primera letra

    if (queryResultSet.isEmpty && value.length == 1) {
      // cargar datos solo la primera vez que se ingresa un carácter
      FirebaseFirestore.instance.collection("categories_italy").get().then((
        QuerySnapshot docs,
      ) {
        for (var doc in docs.docs) {
          var data = doc.data()! as Map<String, dynamic>;

          data.forEach((subCatName, subCatData) {
            if (subCatData is Map<String, dynamic> &&
                subCatData.containsKey('recipes')) {
              // verificar que existe la clave 'recipes' y que es un mapa
              var recipesMap = subCatData['recipes'] as Map<String, dynamic>;

              recipesMap.forEach((recipeName, recipeData) {
                // iterar sobre cada receta y agregarla a queryResultSet
                queryResultSet.add({
                  'name':
                      recipeData['name'] ??
                      recipeName, // usar el nombre de la receta o el nombre del mapa si no existe
                  'image':
                      recipeData['image'] ??
                      'https://via.placeholder.com/150', // placeholder si no existe imagen
                  'ingredients':
                      recipeData['ingredients'] ??
                      [], // usar lista vacía si no existen ingredientes
                  'steps':
                      recipeData['steps'] ??
                      [], // usar lista vacía si no existen pasos
                });
              });
            }
          });
        }

        filterSearch(
          capitalizedValue,
        ); // filtrar resultados después de cargar todos los datos
      });
    } else {
      filterSearch(
        capitalizedValue,
      ); // filtrar resultados en cada cambio de texto después de la primera carga
    }
  }

  void filterSearch(String capitalizedValue) {
    // filtrar resultados de búsqueda
    tempSearchStore = [];

    for (var element in queryResultSet) {
      // agregar a tempSearchStore solo los elementos que coincidan con el texto ingresado
      if ((element["name"] as String).startsWith(capitalizedValue)) {
        tempSearchStore.add(element);
      }
    }

    setState(() {});
  }

  Widget categoryList() {
    // lista de categorías horizontales
    return StreamBuilder(
      // escuchar cambios en la colección de categorías para actualizar la lista automáticamente
      stream: FirebaseFirestore.instance
          .collection("categories_italy")
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        // manejar estados de carga y datos vacíos
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        var docs = snapshot.data.docs;

        // seleccionar primera categoría automáticamente
        if (selectedSubCategory == null && docs.isNotEmpty) {
          selectedSubCategory = docs[0].id;
        }

        return SizedBox(
          // mostrar lista horizontal de categorías con imagen e indicador de selección
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: docs.length, // número de categorías disponibles
            itemBuilder: (context, index) {
              var ds = docs[index];

              String name = ds['name'];
              String icon = ds['icon'];

              bool isSelected =
                  selectedSubCategory ==
                  ds.id; // verificar si la categoría actual es la seleccionada para mostrar el indicador visual

              return GestureDetector(
                // manejar selección de categoría al hacer tap en la categoría correspondiente
                onTap: () {
                  setState(() {
                    selectedSubCategory = ds
                        .id; // actualizar categoría seleccionada para mostrar recetas correspondientes a esa categoría
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
    // mostrar recetas de la categoría seleccionada en una lista horizonta
    if (selectedSubCategory == null) return Container();

    return StreamBuilder(
      stream: FirebaseFirestore
          .instance // acceder a la colección de recetas de la categoría seleccionada para mostrar las recetas correspondientes a esa categoría, escuchando cambios en tiempo real para actualizar la lista automáticamente
          .collection('categories_italy')
          .doc(selectedSubCategory)
          .collection('recipes')
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        // manejar estados de carga y datos vacíos
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        var recipesDocs = snapshot.data.docs;

        if (recipesDocs.isEmpty) return Center(child: Text("No hay recetas"));

        return SizedBox(
          // mostrar lista horizontal de recetas con imagen y nombre, y manejar navegación a la pantalla de detalles de la receta al hacer tap en una receta específica
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recipesDocs.length,
            itemBuilder: (context, index) {
              var recipe = recipesDocs[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Recipe(
                        foodname: recipe['name'],
                        image: recipe['image'],
                        ingredients: recipe['ingredients'],
                        steps: recipe['steps'],
                      ),
                    ),
                  );
                },
                child: Container(
                  // mostrar cada receta en una tarjeta con imagen y nombre, usando valores predeterminados para evitar errores si no existen datos específicos en la receta
                  margin: EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              recipe['image'] ?? 'https://via.placeholder.com/150',
                              height: 100,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            recipe['name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
  
  Widget buildResultCard(data) {
    // mostrar cada resultado de búsqueda en una tarjeta con imagen y nombre de la receta, y manejar navegación a la pantalla de detalles de la receta al hacer tap en un resultado específico
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recipe(
              // manejar navegación a la pantalla de detalles de la receta al hacer tap en un resultado específico, pasando los datos de la receta seleccionada a la pantalla de detalles para mostrar la información correspondiente a esa receta, usando valores predeterminados para evitar errores si no existen datos específicos en la receta
              foodname: data['name'],
              image: data['image'],
              ingredients: data['ingredients'],
              steps: data['steps'],
            ),
          ),
        );
      },
      child: Container(
        // mostrar cada resultado de búsqueda en una tarjeta con imagen y nombre de la receta, usando valores predeterminados para evitar errores si no existen datos específicos en la receta
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
              // mostrar cada resultado de búsqueda en una fila con imagen y nombre de la receta, usando valores predeterminados para evitar errores si no existen datos específicos en la receta
              children: [
                ClipRRect(
                  // mostrar la imagen de la receta en un círculo con un borde redondeado, usando un placeholder si no existe una imagen específica para evitar errores
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 156, 179, 222),
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60, left: 20),
        child: Column(
          children: [
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/images/receta1.jpg",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 156, 179, 222),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (value) => initiateSearch(value),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search_outlined),
                  hintText: "Buscar Receta...",
                ),
              ),
            ),
            SizedBox(height: 20),
            search
                ? ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    children: tempSearchStore
                        .map((e) => buildResultCard(e))
                        .toList(),
                  )
                : categoryList(),
            SizedBox(height: 20),
            search ? Container() : Expanded(child: allRecipe()),
          ],
        ),
      ),
    );
  }
}
