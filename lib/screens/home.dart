import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/category.dart';
import 'package:flutter_application_1/screens/recipe.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widget/support_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  Stream? recipeStream;

  Future<void> getontheload() async {
    recipeStream = await DatabaseMethods().getAllRecipes();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  bool search = false;

  var queryResulrSet = [];
  var tempSearchStore = [];

  void initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResulrSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizedValue = value.isNotEmpty
        ? value[0].toUpperCase() + value.substring(1)
        : value;

    if (queryResulrSet.isEmpty && value.length == 1) {
      DatabaseMethods().Search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResulrSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      for (var element in queryResulrSet) {
        if (element["SearchedName"].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
  }

  Widget allRecipe() {
    return StreamBuilder(
      stream: recipeStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Recipe(
                            foodname: ds["Name"],
                            image: ds["Image"],
                            recipe: ds["Detail"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              ds["Image"],
                              height: 250,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            ds["Name"],
                            style: AppWidget.lightfeildtextstyle(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container();
      },
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
        margin: EdgeInsets.only(top: 40.0, left: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  Text(
                    "Looking for your\nfavourite meal?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
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
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 156, 179, 222),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                onChanged: (value) {
                  initiateSearch(value.toUpperCase());
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search_outlined),
                  hintText: "Search Recipe...",
                ),
              ),
            ),
            SizedBox(height: 20.0),
            search
                ? ListView(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    primary: false,
                    shrinkWrap: true,
                    children: tempSearchStore.map((element) {
                      return buildResultCard(element);
                    }).toList(),
                  )
                : SizedBox(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Category(category: "Soup Recipes"),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/images/receta1.jpg",
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  "Soup Recipes",
                                  style: AppWidget.lightfeildtextstyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Category(category: "Main Course"),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/images/receta1.jpg",
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  "Main Course",
                                  style: AppWidget.lightfeildtextstyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Category(category: "Chinese"),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/images/receta1.jpg",
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  "Chinese",
                                  style: AppWidget.lightfeildtextstyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Category(category: "Italian"),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/images/receta1.jpg",
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  "Italian",
                                  style: AppWidget.lightfeildtextstyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

            SizedBox(height: 20.0),
            search ? Container() : Expanded(child: allRecipe()),
          ],
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recipe(
              foodname: data['Name'],
              image: data['Image'],
              recipe: data['Detail'],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
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
                    data['Image'],
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20.0),
                Text(data['Name'], style: AppWidget.boldfieldtextstyle()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
