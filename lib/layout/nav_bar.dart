import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/add_recipe.dart';
import 'package:flutter_application_1/screens/countries.dart';
import 'package:flutter_application_1/screens/profile/profile.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    CountriesPage(), //navegar a pantalla de selección del pais
    Icon(Icons.favorite, color: Colors.black), //navegar a recetas guardadas
    AddRecipe(), //navegar a pantalla de añadir recetas
    Profile() //navegar a perfil del usuario
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_currentIndex]
        ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: '', backgroundColor: Color.fromARGB(255, 42, 79, 114),),
          BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Colors.white), label: '', backgroundColor: Color.fromARGB(255, 42, 79, 114),),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.white), label: '', backgroundColor: Color.fromARGB(255, 42, 79, 114),),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.white), label: '', backgroundColor: Color.fromARGB(255, 42, 79, 114),),
        ],
      ),
    );
  }
}
