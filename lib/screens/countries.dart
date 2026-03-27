import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CountriesPage extends StatefulWidget {
  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final List<Map<String, String>> countries = [
    {"name": "Italia", "plate": "italia_plate.png", "flag": "🇮🇹"},
    {"name": "México", "plate": "mexico_plate.png", "flag": "🇲🇽"},
    {"name": "Japón", "plate": "japon_plate.png", "flag": "🇯🇵"},
    {"name": "India", "plate": "india_plate.png", "flag": "🇮🇳"},
    {"name": "Tailandia", "plate": "tailandia_plate.png", "flag": "🇹🇭"},
    {"name": "España", "plate": "espania_plate.png", "flag": "🇪🇸"},
    {"name": "Grecia", "plate": "grecia_plate.png", "flag": "🇬🇷"},
    {"name": "Francia", "plate": "francia_plate.png", "flag": "🇫🇷"},
    {"name": "Suiza", "plate": "suiza_plate.png", "flag": "🇨🇭"},
    {"name": "Armenia", "plate": "armenia_plate.png", "flag": "🇦🇲"},
    {"name": "Brasil", "plate": "brasil_plate.png", "flag": "🇧🇷"},
    {"name": "Turquía", "plate": "turquia_plate.png", "flag": "🇹🇷"},
    {"name": "Argentina", "plate": "argentina_plate.png", "flag": "🇦🇷"},
    {"name": "Corea del Sur", "plate": "corea_sur_plate.png", "flag": "🇰🇷"},
    {"name": "Indonesia", "plate": "indonesia_plate.png", "flag": "🇮🇩"},
    {"name": "Estados Unidos", "plate": "estados_unidos_plate.png", "flag": "🇺🇸"},
    {"name": "Alemania", "plate": "alemania_plate.png", "flag": "🇩🇪"},
    {"name": "Perú", "plate": "peru_plate.png", "flag": "🇵🇪"},
    {"name": "Marruecos", "plate": "marruecos_plate.png", "flag": "🇲🇦"},
    {"name": "China", "plate": "china_plate.png", "flag": "🇨🇳"},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF92B0AC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "¿A qué país quieres",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "viajar hoy?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: searchCountry,
                decoration: InputDecoration(
                  hintText: "Buscar país",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: filteredCountries.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: FutureBuilder<String>(
                                future: getImageUrl(country["plate"]!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Icon(Icons.error);
                                  }
                                  return Image.network(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  country["flag"]!,
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  country["name"]!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
