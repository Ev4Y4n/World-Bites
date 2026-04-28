import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/providers/app_state.dart';
import 'package:flutter_application_1/screens/comming_soon.dart';
import 'package:provider/provider.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({super.key});

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final List<Map<String, String>> countries = [
    {
      "name": "Italia",
      "plate": "italia_plate.png",
      "flag": "🇮🇹",
      "categoryID": "categories_italy",
    },
    {
      "name": "México",
      "plate": "mexico_plate.png",
      "flag": "🇲🇽",
      "categoryID": "categories_mexico",
    },
    {
      "name": "Japón",
      "plate": "japon_plate.png",
      "flag": "🇯🇵",
      "categoryID": "categories_japan",
    },
    {
      "name": "India",
      "plate": "india_plate.png",
      "flag": "🇮🇳",
      "categoryID": "categories_india",
    },
    {
      "name": "Tailandia",
      "plate": "tailandia_plate.png",
      "flag": "🇹🇭",
      "categoryID": "categories_thailand",
    },
    {
      "name": "España",
      "plate": "espania_plate.png",
      "flag": "🇪🇸",
      "categoryID": "categories_spain",
    },
  ];

  List<Map<String, String>> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    filteredCountries = countries;
  }

  Future<String> getImageUrl(String imageName) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('Countries')
        .child(imageName);
    return await ref.getDownloadURL();
  }

  void searchCountry(String query) {
    final results = countries.where((country) {
      final name = country["name"]!.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCountries = results;
    });
  }

  void commingSoon() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const CommingSoon()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildCountriesList());
  }

  Widget _buildCountriesList() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "¿A qué país quieres\nviajar hoy?",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              onChanged: searchCountry,
              decoration: InputDecoration(
                hintText: "Buscar país",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: filteredCountries.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final country = filteredCountries[index];

                  return GestureDetector(
                    onTap: () {
                      context.read<AppState>().selectCountry(
                        country["categoryID"]!,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 5),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<String>(
                              future: getImageUrl(country["plate"]!),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(country["flag"]!),
                                const SizedBox(width: 6),
                                Text(country["name"]!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
