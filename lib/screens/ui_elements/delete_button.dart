import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database.dart';

class DeleteButton extends StatelessWidget {
  final String recipeId;
  final String? imageUrl; // opcional si quieres borrar imagen también
  final double size;

  const DeleteButton({
    super.key,
    required this.recipeId,
    this.imageUrl,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

    return GestureDetector(
      onTap: () async {
        await db.deleteUserRecipe(recipeId, imageUrl: imageUrl);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Receta eliminada')));
      },
      child: Container(
        width: size + 12,
        height: size + 12,
        decoration: const BoxDecoration(
          color: Color.fromARGB(137, 255, 255, 255),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.delete, size: size, color: const Color.fromARGB(255, 42, 79, 114)),
      ),
    );
  }
}
