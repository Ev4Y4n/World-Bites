import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/services/database.dart';

class FavoriteButton extends StatefulWidget {
  final String recipeId;

  const FavoriteButton({super.key, required this.recipeId});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  List<String> favourites = [];
  final db = DatabaseService();

  @override
  void initState() {
    super.initState();
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    favourites = await db.getFavorites(uid);
    setState(() {});
  }

  Future<void> toggleFavorite() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await db.toggleFavorite(uid, widget.recipeId);

    // refresco local simple
    if (favourites.contains(widget.recipeId)) {
      favourites.remove(widget.recipeId);
    } else {
      favourites.add(widget.recipeId);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isFav = favourites.contains(widget.recipeId);

    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: toggleFavorite,
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color.fromARGB(137, 255, 255, 255),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite,
            size: 16,
            color: isFav ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }
}
