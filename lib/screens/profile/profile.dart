import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/app_state.dart';
import 'package:flutter_application_1/screens/profile/change_password.dart';
import 'package:flutter_application_1/screens/profile/delete_account.dart';
import 'package:flutter_application_1/screens/profile/register.dart';
import 'package:flutter_application_1/screens/profile/reset_password.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? selectedImage;
  String? imageUrl;
  String username = "Cargando...";
  int followersCount = 0;
  int followingCount = 0;
  int recipesCount = 0;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// Carga inicial del nombre e imagen desde Firestore
  Future<void> loadUserData() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (!mounted || !userDoc.exists) return;

      setState(() {
        imageUrl = userDoc.data()?["profileImage"];
        username = userDoc.data()?["userName"] ?? "Usuario";

        followersCount = userDoc.data()?["followersCount"] ?? 0;
        followingCount = userDoc.data()?["followingCount"] ?? 0;
        recipesCount = userDoc.data()?["recipesCount"] ?? 0;
      });
    } catch (e) {
      print("Error cargando datos: $e");
    }
  }

  /// Actualiza el nombre de usuario en Firebase
  Future<void> updateUsernameInFirebase(String newName) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("Users").doc(uid).update({
        "username": newName,
      });
      setState(() {
        username = newName;
      });
      Fluttertoast.showToast(msg: "Nombre actualizado");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error al actualizar nombre");
    }
  }

  Future getProfileImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted || image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future<void> uploadProfileImage() async {
    if (selectedImage != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("UserProfileImages")
          .child("${FirebaseAuth.instance.currentUser!.uid}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadurl = await (await task).ref.getDownloadURL();

      await DatabaseService().addProfilePicture(
        FirebaseAuth.instance.currentUser!.uid,
        downloadurl,
      );

      setState(() {
        imageUrl = downloadurl;
      });
    } else {
      Fluttertoast.showToast(
        msg: "Error al subir la imagen",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }

  // Navegación y Auth
  void exitApp() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => const Register()));
  void reset() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => const ResetPassword()));
  void delete() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => const DeleteAccount()));

  void logout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cerrar sesión"),
          content: const Text("¿Estás seguro de que quieres cerrar sesión?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Sí, cerrar sesión"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await authService.value.signOut();
        exitApp();
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo decorativo superior
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

          // Foto de Perfil
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: ProfilePic(
                selectedImage: selectedImage,
                imageUrl: imageUrl,
                onPressed: () async {
                  await getProfileImage();
                  uploadProfileImage();
                },
              ),
            ),
          ),

          // Nombre de Usuario Editable
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: UserNameWidget(
                currentName: username,
                onSave: (newName) => updateUsernameInFirebase(newName),
              ),
            ),
          ),

          // Seguidores / Siguiendo / Recetas
          Positioned(
            top: 260,
            left: 0,
            right: 0,
            child: Center(
              child: UserInfo(
                followersCount: followersCount,
                followingCount: followingCount,
                recipesCount: recipesCount,
              ),
            ),
          ),

          // Menú de opciones inferior
          Positioned.fill(
            top: 330,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileMenu(
                    text: "Mis recetas",
                    icon: Icons.local_dining,
                    press: () {
                      context.read<AppState>().setSavedRecipesTab(1);
                      context.read<AppState>().setNavIndex(1);
                    },
                  ),
                  ProfileMenu(
                    text: "Cambiar Contraseña",
                    icon: Icons.change_circle_outlined,
                    press: reset,
                  ),
                  ProfileMenu(
                    text: "Ayuda",
                    icon: Icons.help_outline,
                    press: () {},
                  ),
                  ProfileMenu(
                    text: "Cerrar Sesión",
                    icon: Icons.logout_outlined,
                    press: () => logout(context),
                  ),
                  ProfileMenu(
                    text: "Eliminar Cuenta",
                    icon: Icons.delete_outline,
                    press: delete,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SUB-WIDGETS ---

class ProfilePic extends StatelessWidget {
  final VoidCallback onPressed;
  final File? selectedImage;
  final String? imageUrl;

  const ProfilePic({
    Key? key,
    required this.onPressed,
    this.selectedImage,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.grey[200],
            backgroundImage: selectedImage != null
                ? FileImage(selectedImage!)
                : (imageUrl != null ? NetworkImage(imageUrl!) : null)
                      as ImageProvider?,
            child: (selectedImage == null && imageUrl == null)
                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                : null,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 42, 79, 114),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserNameWidget extends StatefulWidget {
  final String currentName;
  final Function(String) onSave;

  const UserNameWidget({
    Key? key,
    required this.currentName,
    required this.onSave,
  }) : super(key: key);

  @override
  State<UserNameWidget> createState() => _UserNameWidgetState();
}

class _UserNameWidgetState extends State<UserNameWidget> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void didUpdateWidget(covariant UserNameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el nombre cambia en el padre (Firebase), lo reflejamos aquí
    if (oldWidget.currentName != widget.currentName && !isEditing) {
      _controller.text = widget.currentName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isEditing
            ? SizedBox(
                width: 180,
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text(
                widget.currentName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 42, 79, 114),
                ),
              ),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          color: const Color.fromARGB(255, 42, 79, 114),
          onPressed: () {
            if (isEditing) {
              if (_controller.text.trim().isNotEmpty) {
                widget.onSave(_controller.text.trim());
              }
              setState(() => isEditing = false);
            } else {
              setState(() => isEditing = true);
            }
          },
        ),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  final int followersCount;
  final int followingCount;
  final int recipesCount;

  const UserInfo({
    Key? key,
    required this.followersCount,
    required this.followingCount,
    required this.recipesCount,
  }) : super(key: key);

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
            const SizedBox(width: 8),
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
            fontSize: 14,
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

class ProfileMenu extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? press;

  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 42, 79, 114),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 42, 79, 114),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.barlow(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 100, 100, 100),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
