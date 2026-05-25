import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widget/support_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:multiselect/multiselect.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  String? selectedCategory;
  String? selectedDifficulty;
  String? selectedCountry;

  List<Map<String, String>> categories = [];

  List<Map<String, String>> countries = [];

  final List<String> tags = [
    'Vegetariano',
    'Vegano',
    'Sin gluten',
    'Sin lactosa',
    'Sin azúcar',
    'Bajo en calorías',
    'Con gluten',
    'Con lactosa',
    'Alcohol',
    'Sin alcohol',
  ];

  List<String> selectedTags = [];
  final List<String> difficulties = ['Fácil', 'Medio', 'Dificil'];
  List<Map<String, dynamic>> ingredients = [];
  List<Map<String, dynamic>> steps = [];
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController kcalController = TextEditingController();
  TextEditingController ingredientName = TextEditingController();
  TextEditingController ingredientQty = TextEditingController();
  TextEditingController stepController = TextEditingController();

  //CREACIÓN FUNCIÓN QUE ACCEDE A LA GALERÍA DEL MOVIL PARA SELECCIONAR UNA FOTO
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  void loadCountries() async {
    final data = await DatabaseService().getCountries();

    setState(() {
      countries = data;
    });
  }

  void loadCategories(String countryId) async {
    final data = await DatabaseService().getCategoriesByCountry(countryId);

    setState(() {
      categories = data;
      selectedCategory = null;
    });
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<void> uploadItem() async {
    print("IMAGE: $selectedImage");
    print("NAME: ${nameController.text}");
    print("COUNTRY: $selectedCountry");
    print("CATEGORY: $selectedCategory");
    print("DIFFICULTY: $selectedDifficulty");
    print("INGREDIENTS: ${ingredients.length}");
    print("STEPS: ${steps.length}");
    if (selectedImage == null ||
        nameController.text.trim().isEmpty ||
        selectedCountry == null ||
        selectedCategory == null ||
        selectedDifficulty == null ||
        ingredients.isEmpty ||
        steps.isEmpty) {
      Fluttertoast.showToast(
        msg: "Faltan campos por rellenar",
        backgroundColor: const Color.fromARGB(255, 42, 79, 114),
        textColor: Colors.white,
      );

      return;
    }

    try {
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("UserRecipes")
          .child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadurl = await (await task).ref.getDownloadURL();

      Map<String, dynamic> addrecipe = {
        "name": nameController.text,
        "image": downloadurl,
        "category": selectedCategory,
        "difficulty": selectedDifficulty,
        "prepTime": int.parse(timeController.text),
        "quantity": int.parse(quantityController.text),
        "kcal": int.parse(kcalController.text),
        "ingredients": ingredients,
        "steps": steps,
        "tags": selectedTags,
        "country": selectedCountry,
        "userId": FirebaseAuth.instance.currentUser?.uid,
        "key": nameController.text.substring(0, 1).toUpperCase(),
        "searchedName": nameController.text.toUpperCase(),
      };

      await DatabaseService().addRecipe(addrecipe);

      Fluttertoast.showToast(
        msg: "Receta añadida a la base de datos",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al guardar receta",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      print("ERROR ADD RECIPE: $e");
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
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nombre Receta ...",
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: countries.map((item) {
                      return DropdownMenuItem<String>(
                        value: item["id"], // valor real (japan)
                        child: Text(
                          item["name"]!, // lo que ve el usuario (Japón)
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      );
                    }).toList(),

                    onChanged: (countryId) {
                      setState(() {
                        selectedCountry = countryId;
                      });

                      loadCategories(countryId!);
                    },

                    dropdownColor: Colors.white,
                    hint: Text("Selecciona País"),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: selectedCountry,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: categories
                        .map(
                          (item) => DropdownMenuItem(
                            value: item["id"],
                            child: Text(
                              item["name"]!,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: ((category) => setState(() {
                      this.selectedCategory = category;
                    })),
                    dropdownColor: Colors.white,
                    hint: Text("Selecciona Categoría"),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: selectedCategory,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: difficulties
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
                    onChanged: ((difficulty) => setState(() {
                      this.selectedDifficulty = difficulty;
                    })),
                    dropdownColor: Colors.white,
                    hint: Text("Dificultad ..."),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: selectedDifficulty,
                  ),
                ),
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
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tiempo preparación ...",
                  ),
                ),
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
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Cantidad ...",
                  ),
                ),
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
                  controller: kcalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Kcal ...",
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text("Ingredientes", style: AppWidget.boldfieldtextstyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ingredientName,
                        decoration: InputDecoration(hintText: "Nombre"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: ingredientQty,
                        decoration: InputDecoration(hintText: "Cantidad"),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          ingredients.add({
                            "name": ingredientName.text,
                            "quantity": ingredientQty.text,
                          });

                          ingredientName.clear();
                          ingredientQty.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(ingredients[index]["name"]),
                    subtitle: Text(ingredients[index]["quantity"]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          ingredients.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
              Text("Pasos", style: AppWidget.boldfieldtextstyle()),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: stepController,
                        decoration: InputDecoration(
                          hintText: "Añadir paso ...",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          steps.add({"description": stepController.text});
                          stepController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "${index + 1}. ${steps[index]["description"]}",
                    ), // Muestra el número del paso junto con su descripción
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          steps.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      selectedTags = x;
                    });
                  },
                  options: tags,
                  selectedValues: selectedTags,
                  whenEmpty: 'Selecciona al menos una etiqueta',
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  uploadItem();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  margin: EdgeInsets.only(bottom: 40.0),
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
