import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CountriesPage extends StatelessWidget {
  final List<Map<String, String>> countries = [
    {
      "name": "Italia",
      "plate": "assets/images/italia_plate.png",
      "flag": "assets/images/italia_flag.png",
    },
    {
      "name": "México",
      "plate": "assets/images/mexico_plate.png",
      "flag": "assets/images/mexico_flag.png",
    },
    {
      "name": "Japón",
      "plate": "assets/images/japon_plate.png",
      "flag": "assets/images/japon_flag.png",
    },
    {
      "name": "India",
      "plate": "assets/images/india_plate.png",
      "flag": "assets/images/india_flag.png",
    },
    {
      "name": "Tailandia",
      "plate": "assets/images/tailandia_plate.png",
      "flag": "assets/images/tailandia_flag.png",
    },
    {
      "name": "España",
      "plate": "assets/images/espania_plate.png",
      "flag": "assets/images/espania_flag.png",
    },
    {
      "name": "Grecia",
      "plate": "assets/images/grecia_plate.png",
      "flag": "assets/images/grecia_flag.png",
    },
    {
      "name": "Francia",
      "plate": "assets/images/francia_plate.png",
      "flag": "assets/images/francia_flag.png",
    },
    {
      "name": "Suiza",
      "plate": "assets/images/suiza_plate.png",
      "flag": "assets/images/suiza_flag.png",
    },
    {
      "name": "Armenia",
      "plate": "assets/images/armenia_plate.png",
      "flag": "assets/images/armenia_flag.png",
    },
    {
      "name": "Brasil",
      "plate": "assets/images/brasil_plate.png",
      "flag": "assets/images/brasil_flag.png",
    },
    {
      "name": "Turquía",
      "plate": "assets/images/turquia_plate.png",
      "flag": "assets/images/turquia_flag.png",
    },
    {
      "name": "Argentina",
      "plate": "assets/images/argentina_plate.png",
      "flag": "assets/images/argentina_flag.png",
    },
    {
      "name": "Corea del sur",
      "plate": "assets/images/corea_sur_plate.png",
      "flag": "assets/images/corea_sur_flag.png",
    },
    {
      "name": "Indonesia",
      "plate": "assets/images/indonesia_plate.png",
      "flag": "assets/images/indonesia_flag.png",
    },
    {
      "name": "Estados Unidos",
      "plate": "assets/images/estados_unidos_plate.png",
      "flag": "assets/images/estados_unidos_flag.png",
    },
    {
      "name": "Alemania",
      "plate": "assets/images/alemania_plate.png",
      "flag": "assets/images/alemania_flag.png",
    },
    {
      "name": "Perú",
      "plate": "assets/images/peru_plate.png",
      "flag": "assets/images/peru_flag.png",
    },
    {
      "name": "Marrruecos",
      "plate": "assets/images/marruecos_plate.png",
      "flag": "assets/images/marruecos_flag.png",
    },
    {
      "name": "China",
      "plate": "assets/images/china_plate.png",
      "flag": "assets/images/china_flag.png",
    },
  ];

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
                "¿A qué país quieres viajar hoy?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              TextField(
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
                  itemCount: countries.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final country = countries[index];

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
                              child: Image.asset(
                                country["plate"]!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  country["flag"]!,
                                  width: 22,
                                  height: 16,
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
