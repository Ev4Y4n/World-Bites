import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String? selectedCountryID;

  void selectCountry(String? countryID) { //se añade ? para que también e permitan valores nulos, lo que indica que no se ha seleccionado ningún país
    selectedCountryID = countryID;
    notifyListeners();
  }
  void clearCountry() {
    selectedCountryID = null;
    notifyListeners();
  }
}
