import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/ui_elements/recipe_card.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pantalla de perfil público de otro usuario.
/// Recibe el [userId] del usuario cuyo perfil se quiere ver.
/// Uso: Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfile(userId: data['userId'])));
class PublicProfile extends StatefulWidget {
  final String userId;

  const PublicProfile({super.key, required this.userId});

  @override
  State<PublicProfile> createState() => _PublicProfileState();
}

class _PublicProfileState extends State<PublicProfile> {
  // Datos del usuario visitado
  String username = "Cargando...";
  String? imageUrl;
  int followersCount = 0;
  int followingCount = 0;
  int recipesCount = 0;

  // Estado del botón seguir
  bool isFollowing = false;
  bool isLoadingFollow = false;

  // ID del usuario actual (quien visita el perfil)
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /// Carga los datos del perfil del usuario visitado
  Future<void> _loadProfileData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.userId)
          .get();

      if (!mounted || !userDoc.exists) return;

      final data = userDoc.data()!;
      final List followers = data["followers"] ?? [];
      final List following = data["following"] ?? [];

      // Conteo de recetas usando el mismo método que database.dart
      final recipesSnap = await FirebaseFirestore.instance
          .collection("Recipe")
          .where("userId", isEqualTo: widget.userId)
          .get();

      if (!mounted) return;

      setState(() {
        username = data["userName"] ?? "Usuario";
        imageUrl = data["profileImage"];
        followersCount = followers.length;
        followingCount = following.length;
        recipesCount =
            recipesSnap.docs.length;
        isFollowing = followers.contains(currentUserId);
      });
    } catch (e) {
      debugPrint("Error cargando perfil público: $e");
    }
  }

  /// Sigue o deja de seguir al usuario
  Future<void> _toggleFollow() async {
    if (isLoadingFollow) return;
    setState(() => isLoadingFollow = true);

    final visitedRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userId);
    final currentRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserId);

    try {
      if (isFollowing) {
        // Dejar de seguir:
        // - quitar currentUserId de followers del visitado
        // - quitar widget.userId de following del actual
        await visitedRef.update({
          "followers": FieldValue.arrayRemove([currentUserId]),
        });
        await currentRef.update({
          "following": FieldValue.arrayRemove([widget.userId]),
        });
        if (!mounted) return;
        setState(() {
          isFollowing = false;
          followersCount = (followersCount - 1).clamp(0, 999999);
        });
      } else {
        // Seguir:
        // - añadir currentUserId a followers del visitado
        // - añadir widget.userId a following del actual
        await visitedRef.update({
          "followers": FieldValue.arrayUnion([currentUserId]),
        });
        await currentRef.update({
          "following": FieldValue.arrayUnion([widget.userId]),
        });
        if (!mounted) return;
        setState(() {
          isFollowing = true;
          followersCount = followersCount + 1;
        });
      }
    } catch (e) {
      debugPrint("Error al seguir/dejar de seguir: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al actualizar. Inténtalo de nuevo."),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoadingFollow = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo decorativo superior (mismo que Profile)
          Positioned(
            top: -30,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/fondo_titulo_v3.png',
              height: 250,
              fit: BoxFit.cover,
            ),
          ),

          // Botón atrás
          Positioned(
            top: 50,
            left: 16,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          // Foto de perfil (solo lectura, sin botón de editar)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(child: _PublicProfilePic(imageUrl: imageUrl)),
          ),

          // Nombre de usuario (solo lectura)
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 42, 79, 114),
                ),
              ),
            ),
          ),

          // Estadísticas: seguidores / siguiendo / recetas
          Positioned(
            top: 238,
            left: 0,
            right: 0,
            child: Center(
              child: _UserStats(
                followersCount: followersCount,
                followingCount: followingCount,
                recipesCount: recipesCount,
              ),
            ),
          ),

          // Botón Seguir / Siguiendo
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Center(
              child: _FollowButton(
                isFollowing: isFollowing,
                isLoading: isLoadingFollow,
                onTap: _toggleFollow,
              ),
            ),
          ),

          // Lista de recetas del usuario
          Positioned.fill(
            top: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Text(
                    "Recetas",
                    style: GoogleFonts.barlow(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 42, 79, 114),
                    ),
                  ),
                ),
                Expanded(child: _UserRecipesList(userId: widget.userId)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

/// Foto de perfil de solo lectura (sin botón de editar)
class _PublicProfilePic extends StatelessWidget {
  final String? imageUrl;

  const _PublicProfilePic({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 55,
      backgroundColor: Colors.grey[200],
      backgroundImage: imageUrl != null
          ? NetworkImage(imageUrl!) as ImageProvider
          : null,
      child: imageUrl == null
          ? const Icon(Icons.person, size: 60, color: Colors.grey)
          : null,
    );
  }
}

/// Fila de estadísticas (seguidores / siguiendo / recetas)
class _UserStats extends StatelessWidget {
  final int followersCount;
  final int followingCount;
  final int recipesCount;

  const _UserStats({
    required this.followersCount,
    required this.followingCount,
    required this.recipesCount,
  });

  Widget _buildStatColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 100, 100, 100),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color.fromARGB(255, 100, 100, 100),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatColumn(
          Icons.person_add_outlined,
          followersCount.toString(),
          'seguidores',
        ),
        const SizedBox(width: 25),
        _buildStatColumn(
          Icons.person_add_outlined,
          followingCount.toString(),
          'siguiendo',
        ),
        const SizedBox(width: 25),
        _buildStatColumn(
          Icons.local_dining,
          recipesCount.toString(),
          'recetas',
        ),
      ],
    );
  }
}

/// Botón de seguir / dejar de seguir
class _FollowButton extends StatelessWidget {
  final bool isFollowing;
  final bool isLoading;
  final VoidCallback onTap;

  const _FollowButton({
    required this.isFollowing,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 160,
        height: 42,
        decoration: BoxDecoration(
          color: isFollowing
              ? Colors.white
              : const Color.fromARGB(255, 42, 79, 114),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color.fromARGB(255, 42, 79, 114),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 42, 79, 114).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isFollowing
                        ? const Color.fromARGB(255, 42, 79, 114)
                        : Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isFollowing
                          ? Icons.person_remove_outlined
                          : Icons.person_add_outlined,
                      size: 18,
                      color: isFollowing
                          ? const Color.fromARGB(255, 42, 79, 114)
                          : Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isFollowing ? "Siguiendo" : "Seguir",
                      style: GoogleFonts.barlow(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isFollowing
                            ? const Color.fromARGB(255, 42, 79, 114)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Lista de recetas publicadas por el usuario visitado
class _UserRecipesList extends StatelessWidget {
  final String userId;

  const _UserRecipesList({required this.userId});

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.getUserRecipes(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 42, 79, 114),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.dining_outlined,
                  size: 60,
                  color: Color.fromARGB(255, 200, 200, 200),
                ),
                const SizedBox(height: 12),
                Text(
                  "Aún no hay recetas publicadas",
                  style: GoogleFonts.barlow(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 150, 150, 150),
                  ),
                ),
              ],
            ),
          );
        }

        final recipes = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final doc = recipes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: RecipeCard(
                doc: doc,
                recipe: doc.data(),
                onFavoriteTap: () {},
              ),
            );
          },
        );
      },
    );
  }
}

/// Tarjeta de receta individual, con el mismo estilo que el resto de la app
class _RecipeCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _RecipeCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final String title = data["title"] ?? "Sin título";
    final String? imageUrl = data["imageUrl"];
    final String category = data["category"] ?? "";
    final int? duration = data["duration"]; // minutos, si existe en tu modelo

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Imagen de la receta
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),

            const SizedBox(width: 14),

            // Info de la receta
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.barlow(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 42, 79, 114),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        category,
                        style: GoogleFonts.barlow(
                          fontSize: 13,
                          color: const Color.fromARGB(255, 130, 130, 130),
                        ),
                      ),
                    ],
                    if (duration != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Color.fromARGB(255, 100, 100, 100),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$duration min",
                            style: GoogleFonts.barlow(
                              fontSize: 13,
                              color: const Color.fromARGB(255, 100, 100, 100),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Flecha derecha (igual que ProfileMenu)
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF757575),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 90,
      height: 90,
      color: const Color.fromARGB(255, 220, 225, 232),
      child: const Icon(
        Icons.local_dining,
        color: Color.fromARGB(255, 42, 79, 114),
        size: 36,
      ),
    );
  }
}
