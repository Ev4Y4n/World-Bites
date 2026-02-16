import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class Recipe extends StatefulWidget {
  const Recipe({super.key});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/receta1.jpg",
              width: MediaQuery.of(context).size.width,
              height: 400,
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 1.1,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Receta 1",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 10.0,),
                  Text("Instrucciones", style: AppWidget.lightfeildtextstyle(),),
                  SizedBox(height: 10.0,),
                  Text("1. Divide la carne en dos bolas y aplástalas directamente en la sartén caliente.\n2. Añade sal y pimienta y cocina 2–3 minutos por lado.\n3. Coloca el cheddar encima y deja que se funda.\n4. Tuesta ligeramente los panes.\n5. Monta la hamburguesa con salsa, lechuga, carne, tomate, cebolla y pepinillos.\n6. Sirve caliente y disfruta."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
