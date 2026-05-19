import 'package:flutter/material.dart';

//se utiliza para compartir el estado de la aplicación, como la categoría seleccionada, entre diferentes pantallas sin necesidad de pasar datos manualmente a través de constructores o usar rutas. Esto es especialmente útil para mantener la consistencia de la interfaz de usuario y mejorar la experiencia del usuario al navegar por la aplicación.
class AppState extends ChangeNotifier {
  String? selectedCountryID;

  int navIndex = 0;
  int savedRecipesTab = 0;
  String? profileScreen;

  void setSavedRecipesTab(int tab) {
    savedRecipesTab = tab;
    notifyListeners();
  }

  void selectCountry(String? countryID) {
    //se añade ? para permitir que se pueda pasar null y así limpiar la selección de país
    selectedCountryID = countryID;
    notifyListeners();
  }

  void clearCountry() {
    selectedCountryID = null;
    notifyListeners();
  }

  void setNavIndex(int index) {
    navIndex = index;
    notifyListeners();
  }

  void setProfileScreen(String? screen) {
    profileScreen = screen;
    notifyListeners();
  }
}
