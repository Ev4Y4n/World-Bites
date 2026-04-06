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
                  'difficulty':
                      recipeData['difficulty'] ??
                      'Desconocida', // usar valor predeterminado si no existe dificultad
                  'favorite':
                      recipeData['favorite'] ??
                      false, // usar false si no existe información de favorito
                  'image':
                      recipeData['image'] ??
                      'https://via.placeholder.com/150', // placeholder si no existe imagen
                  'ingredients':
                      recipeData['ingredients'] ??
                      [], // usar lista vacía si no existen ingredientes
                  'kcal':
                      recipeData['kcal'] ??
                      0, // usar 0 si no existe información de calorías
                  'steps':
                      recipeData['steps'] ??
                      [], // usar lista vacía si no existen pasos
                  'prepTime':
                      recipeData['prepTime'] ??
                      0, // usar 0 si no existe información de tiempo de preparación
                  'servings':
                      recipeData['servings'] ??
                      0, // usar 0 si no existe información de porciones
                  'tags':
                      recipeData['tags'] ??
                      [], // usar lista vacía si no existen etiquetas
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
            crossAxisCount: 2, // 2 columnas
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75, // ajusta tamaño de cada card
          ),
          itemCount: recipesDocs.length,
          itemBuilder: (context, index) {
            var recipe =
                recipesDocs[index].data()
                    as Map<
                      String,
                      dynamic
                    >; // obtener datos de cada receta para mostrar en la tarjeta, usando valores predeterminados para evitar errores si no existen datos específicos en la receta

            var prepTime = recipe['prepTime'];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Recipe(
                      // manejar navegación a la pantalla de detalles de la receta al hacer tap en una receta específica, pasando los datos de la receta seleccionada a la pantalla de detalles para mostrar la información correspondiente a esa receta, usando valores predeterminados para evitar errores si no existen datos específicos en la receta
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
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Agregado a favoritos: ${recipe['name'] ?? 'Receta'}",
                                    ),
                                  ),
                                );
                                setState(() {
                                  recipe['favorite'] = true;
                                });
                              },
                              child: Container(
                                width: 24, // tamaño del fondo
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                    137,
                                    255,
                                    255,
                                    255,
                                  ), // fondo del círculo
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.favorite,
                                    size: 16, // tamaño del ícono
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
                          // El nombre ocupa todo el espacio disponible a la izquierda
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
                          // El prepTime siempre fijo a la derecha
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(136, 104, 92, 92),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min, // se ajusta al contenido
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
                        spacing: 4, // espacio horizontal entre tags
                        runSpacing: 4, // espacio vertical
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
              difficulty: data['difficulty'],
              isFavorite: data['favorite'],
              kcal: data['kcal'],
              prepTime: data['prepTime'],
              servings: data['servings'],
              tags: data['tags'],
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 60, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: const Color.fromARGB(119, 146, 176, 172),
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
                      physics: NeverScrollableScrollPhysics(),
                      children: tempSearchStore
                          .map((e) => buildResultCard(e))
                          .toList(),
                    )
                  : categoryList(),

              SizedBox(height: 20),

              search ? Container() : allRecipe(),
            ],
          ),
        ),
      ),
    );
  }
}
