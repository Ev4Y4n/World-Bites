import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/recipe.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class Category extends StatefulWidget {
  String category;   //Recibe el nombre de la categoría
  Category({super.key, required this.category});

  @override
  State<Category> createState() => _Category();
}

class _Category extends State<Category> {
  Stream? categoryStream; //Aquí guardamos el stream (datos en tiempo real desde Firebase)

  //Método que carga los datos desde Firebase
  Future<void> getOnTheLoad() async {
    categoryStream = DatabaseMethods().getRecipeCategory(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad(); //ejecuta al abrir la pantalla para cargar los datos de la categoría
    super.initState();
  }

 //Widget que pinta TODAS las recetas de la categoría
  Widget allRecipe() {
    return StreamBuilder(
      stream: categoryStream,  //Escucha cambios en Firebase en tiempo real
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  //Define la cuadrícula (2 columnas)
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: snapshot.data.docs.length, //Número de recetas
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index]; //Cada receta (documento) de Firebase
                  return GestureDetector(
                    onTap: () { //Al hacer clic en una receta, navega a la pantalla de detalles de la receta
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Recipe(
                            //Pasa los datos de la receta a la pantalla de detalles
                            foodname: ds["name"],
                            image: ds["icon"],
                            ingredients: ds["ingredients"],
                            steps: ds["steps"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, //Alinea el contenido a la izquierda
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network( //Muestra la imagen de la receta (url)
                              ds["image"],
                              height: 150,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            ds["name"], //Muestra el nombre de la receta
                            style: AppWidget.lightfeildtextstyle(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container(); //Si no hay datos, muestra un contenedor vacío
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Center( //Muestra el nombre de la categoría en la parte superior
              child: Text(
                widget.category, //El nombre de la categoría que se recibió al crear el widget (viene del MainScreen)
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Expanded(child: allRecipe()),//Llama al widget que muestra todas las recetas de la categoría, ocupa el espacio restante
          ],
        ),
      ),
    );
  }
}
