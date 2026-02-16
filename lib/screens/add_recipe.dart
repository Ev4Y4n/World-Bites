import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Añadir receta",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Icon(Icons.camera_alt_outlined),
              ),
            ),
            SizedBox(height: 20.0),
            Text("Nombre Receta", style: AppWidget.boldfieldtextstyle()),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Nombre Receta ...",
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text("Instrucciones Receta", style: AppWidget.boldfieldtextstyle()),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                maxLines: 12,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Instrucciones Receta ...",
                ),
              ),
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.only(top:10.0, bottom: 10.0),
              decoration:BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text("GUARDAR", style: TextStyle(color: Colors.white, fontSize: 20.0))),
            ),
          ],
        ),
      ),
    );
  }
}
