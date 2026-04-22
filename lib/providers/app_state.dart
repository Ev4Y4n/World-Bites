import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String? selectedCountryID;

  void selectCountry(String countryID) {
    selectedCountryID = countryID;
    notifyListeners();
  }
}
