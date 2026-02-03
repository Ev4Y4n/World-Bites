import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<void> cargarJson() async {
  final String response = await rootBundle.loadString('jsons/paises.json');
  final data = json.decode(response);
  print(data);
}
