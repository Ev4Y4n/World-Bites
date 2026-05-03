import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedRecipes extends StatefulWidget {
  const SavedRecipes({super.key});

  @override
  State<SavedRecipes> createState() => _SavedRecipesState();
}

class _SavedRecipesState extends State<SavedRecipes> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 110,
        title: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Recetas\n',
                  style: GoogleFonts.barlow(fontSize: 35, color: Colors.white),
                ),
                TextSpan(
                  text: 'Guardadas',
                  style: GoogleFonts.barlow(fontSize: 30, color: Colors.white),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Image.asset(
                'assets/images/fondo_titulo_v2.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 230,
            right: 0,
            child: SafeArea(
              top: false,
              child: Image.asset(
                'assets/images/tenedor_1.png',
                width: 180,
                height: 180,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 180)),
          Container(
            padding: const EdgeInsets.only(top: 250),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTab == 0
                        ? const Color.fromARGB(255, 42, 79, 114)
                        : const Color.fromARGB(255, 203, 212, 221),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedTab = 0;
                    });
                  },
                  child: const Text(
                    'FAVORITOS',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),

                const SizedBox(width: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTab == 1
                        ? const Color.fromARGB(255, 42, 79, 114)
                        : const Color.fromARGB(255, 203, 212, 221),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedTab = 1;
                    });
                  },
                  child: const Text(
                    'MIS RECETAS',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 320),
              child: selectedTab == 0
                  ? Container(
                    child: const Text(
                        "FAVORITOS",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                  )
                  : Container(
                    child: const Text(
                        "MIS RECETAS",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
