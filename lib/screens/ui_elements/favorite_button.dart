import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/services/database.dart';

class FavoriteButton extends StatefulWidget {
  final String recipeId;
  final double size;

  const FavoriteButton({
    super.key,
    required this.recipeId,
    this.size = 24,
  });

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

    if (!mounted) return;
    setState(() {});
  }

  Future<void> toggleFavorite() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await db.toggleFavorite(uid, widget.recipeId);

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

    return GestureDetector(
      onTap: toggleFavorite,
      child: Container(
        width: widget.size + 12,
        height: widget.size + 12,
        decoration: const BoxDecoration(
          color: Color.fromARGB(137, 255, 255, 255),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite,
          size: widget.size,
          color: isFav ? Colors.red : Colors.grey,
        ),
      ),
    );
  }
}