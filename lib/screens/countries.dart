import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/providers/app_state.dart';
import 'package:flutter_application_1/screens/comming_soon.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({super.key});

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  List<Map<String, String>> countries = [];
  List<Map<String, String>> filteredCountries = [];

  Future<void> loadCountries() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("countries")
        .get();

    final data = snapshot.docs.map((doc) {
      final d = doc.data();

      return {
        "name": d["name"].toString(),
        "flag": d["flag"].toString(),
        "plate": d["plate"].toString(),
        "categoryID": d["categoryID"].toString(),
      };
    }).toList();

    setState(() {
      countries = data;
      filteredCountries = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCountries();
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
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(136, 97, 87, 87),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        commingSoon();
                      },
                      icon: const Icon(
                        Icons.mark_chat_unread_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              "¿A qué país quieres\nviajar hoy?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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

                  final isAvailable =
                      country["name"] == "Italia" ||
                      country["name"] == "México";

                  return GestureDetector(
                    onTap: isAvailable
                        ? () {
                            context.read<AppState>().selectCountry(
                              country["categoryID"]!,
                            );
                          }
                        : null,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: isAvailable ? 1 : 0.5,
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
                        ),

                        // 🔒 OVERLAY PRÓXIMAMENTE
                        if (!isAvailable)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text(
                                  "PRÓXIMAMENTE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
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
