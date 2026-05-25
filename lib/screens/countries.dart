import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/providers/app_state.dart';
import 'package:flutter_application_1/screens/comming_soon.dart';
import 'package:provider/provider.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({super.key});
  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  List<Map<String, dynamic>> _allCountries = [];
  List<Map<String, dynamic>> _filteredCountries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  // Carga los países desde Firestore al entrar a la pantalla
  Future<void> _loadCountries() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('countries')
        .get();

    // Convertimos cada documento en un Map sencillo
    final countries = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'name':       data['name']       ?? '',
        'flag':       data['flag']       ?? '',
        'plate':      data['plate']      ?? '',
        'categoryID': data['categoryID'] ?? '',
      };
    }).toList();

    setState(() {
      _allCountries    = countries;
      _filteredCountries = countries;
      _isLoading       = false;
    });
  }

  // Filtra la lista cuando el usuario escribe en el buscador
  void _searchCountry(String query) {
    setState(() {
      _filteredCountries = _allCountries.where((country) {
        return country['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mientras carga, mostramos un spinner
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(body: _buildCountriesList());
  }

  Widget _buildCountriesList() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [

          // Botón de chat arriba a la derecha
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(136, 97, 87, 87),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CommingSoon()),
                  ),
                  icon: const Icon(Icons.mark_chat_unread_outlined, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Text(
            "¿A qué país quieres\nviajar hoy?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Buscador
          TextField(
            onChanged: _searchCountry,
            decoration: InputDecoration(
              hintText: "Buscar país",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 20),

          // Grid de países
          Expanded(
            child: GridView.builder(
              itemCount: _filteredCountries.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) => _buildCountryCard(_filteredCountries[index]),
            ),
          ),

        ]),
      ),
    );
  }

  // Tarjeta individual de cada país
  Widget _buildCountryCard(Map<String, dynamic> country) {
    return GestureDetector(
      onTap: () => context.read<AppState>().selectCountry(country['categoryID']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(children: [

          // Imagen del plato (ocupa la mayor parte de la tarjeta)
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                country['plate'],
                fit: BoxFit.cover,
                width: double.infinity,
                // Mientras carga la imagen, spinner
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : const Center(child: CircularProgressIndicator()),
                // Si la imagen falla, icono de error
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              ),
            ),
          ),

          // Bandera + nombre del país
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(country['flag'], width: 24, height: 24),
                const SizedBox(width: 6),
                Text(country['name']),
              ],
            ),
          ),

        ]),
      ),
    );
  }
}