import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/app_state.dart';
import 'package:flutter_application_1/screens/add_recipe.dart';
import 'package:flutter_application_1/screens/countries.dart';
import 'package:flutter_application_1/screens/profile/profile.dart';
import 'package:flutter_application_1/screens/home.dart';
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

    if (index == 1) return const Icon(Icons.favorite);
    if (index == 2) return AddRecipe();
    if (index == 3) return Profile();

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountry = context.watch<AppState>().selectedCountryID;

    return Scaffold(
      body: _buildPage(_currentIndex, selectedCountry),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color.fromARGB(255, 42, 79, 114),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.public), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
