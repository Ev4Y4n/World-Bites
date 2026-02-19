import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widget/support_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  String? value;
  final List<String> recipe = [
    'Soup Recipes',
    'Main Course',
    'Chinese',
    'Italian',
  ];
  File? selectedImage;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController detailcontroller = new TextEditingController();

  //CREACIÓN FUNCIÓN QUE ACCEDE A LA GALERÍA DEL MOVIL PARA SELECCIONAR UNA FOTO
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  uploadItem() async {
    if (selectedImage != null &&
        namecontroller.text != "" &&
        detailcontroller.text != "") {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blocgImage")
          .child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadurl = await (await task).ref.getDownloadURL();

      Map<String, dynamic> addrecipe = {
        "Name": namecontroller.text,
        "Detail": detailcontroller.text,
        "Image": downloadurl,
        "Category": value,
      };
      DatabaseMethods().Addrecipe(addrecipe).then((value) {
        Fluttertoast.showToast(
          msg: "Receta añadida a la base de datos",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        setState(() {
          namecontroller.clear();
          detailcontroller.clear();
          selectedImage = null;
        });
      });
    } else {
      Fluttertoast.showToast(
        msg: "Faltan campos por rellenar",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Añadir receta",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              selectedImage != null
                  ? GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(),
                          ),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(10),
                            child: Icon(Icons.camera_alt_outlined),
                          ),
                        ),
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nombre Receta ...",
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all()
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: recipe
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                        onChanged: ((value)=> setState(() {
                          this.value= value;
                        })),
                        dropdownColor: Colors.white,
                        hint: Text("Select Category"),
                        iconSize: 36,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                        value: value,
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                "Instrucciones Receta",
                style: AppWidget.boldfieldtextstyle(),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: detailcontroller,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Instrucciones Receta ...",
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  uploadItem();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "GUARDAR",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
