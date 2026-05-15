import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/app_state.dart';
import 'package:flutter_application_1/screens/add_recipe.dart';
import 'package:flutter_application_1/screens/countries.dart';
import 'package:flutter_application_1/screens/explore.dart';
import 'package:flutter_application_1/screens/profile/profile.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/saved_recipes.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  /// Construye la pantalla correcta SIN reconstruir todo el árbol entero.
  Widget _buildPage(int index, String? selectedCountry) {
    if (index == 0) {
      if (selectedCountry == null || selectedCountry.isEmpty) {
        return const CountriesPage();
      } else {
        return MainScreen(categoryID: selectedCountry);
      }
    }

    if (index == 1) return SavedRecipes();
    if (index == 2) return const Explore();
    if (index == 3) return AddRecipe();
    if (index == 4) return Profile();

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountry = context.watch<AppState>().selectedCountryID;

    return Scaffold(
      body: _buildPage(_currentIndex, selectedCountry),
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 42, 79, 114),
        animationDuration: const Duration(milliseconds: 400),
        items: const [
          Icon(Icons.public, color: Colors.white),
          Icon(Icons.favorite, color: Colors.white),
          Icon(Icons.explore, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}
