import 'package:flutter/material.dart';

class PantallaRecetas extends StatelessWidget {
  const PantallaRecetas({
    super.key,
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "ID: $id",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.star, color: Colors.red[500]),
                const SizedBox(width: 6),
                const Text('41'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
