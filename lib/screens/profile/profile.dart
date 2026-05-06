import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile/change_password.dart';
import 'package:flutter_application_1/screens/profile/delete_account.dart';
import 'package:flutter_application_1/screens/profile/register.dart';
import 'package:flutter_application_1/screens/profile/reset_password.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? selectedImage;
  String? imageUrl;
  final ImagePicker _picker = ImagePicker();

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
    } else {
      Fluttertoast.showToast(
        msg: "Error al subir la imagen",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }

  void exitApp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const Register()));
  }

  void reset() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const ResetPassword()),
    );
  }

  void change() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => ChangePassword()));
  }

  void delete() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const DeleteAccount()),
    );
  }

  void logout() async {
    try {
      await authService.value.signOut();
      exitApp();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override //overide se utiliza para cargar la imagen de perfil al iniciar la pantalla de perfil, si el usuario ya tiene una imagen de perfil guardada en la base de datos, se carga esa imagen en lugar del icono por defecto
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future loadProfileImage() async {
    var userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (!userDoc.exists) return;

    setState(() {
      imageUrl = userDoc.data()?["profileImage"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo
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

          // Avatar
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: ProfilePic(
                selectedImage: selectedImage,
                imageUrl: imageUrl,
                onPressed: () async {
                  print("CLICK EN CÁMARA");
                  await getProfileImage();
                  uploadProfileImage();
                },
              ),
            ),
          ),

          // Nombre
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: const Center(child: UserName()),
          ),

          // Info
          Positioned(
            top: 260,
            left: 0,
            right: 0,
            child: const Center(child: UserInfo()),
          ),

          Positioned.fill(
            top: 330,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileMenu(
                    text: "Tus recetas",
                    textStyle: GoogleFonts.barlow(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 100, 100, 100),
                    ),
                    icon: Icons.local_dining,
                    press: () {},
                  ),
                  ProfileMenu(
                    text: "Cambiar Contraseña",
                    textStyle: GoogleFonts.barlow(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 100, 100, 100),
                    ),
                    icon: Icons.change_circle_outlined,
                    press: () {
                      reset();
                    },
                  ),
                  ProfileMenu(
                    text: "Ayuda",
                    textStyle: GoogleFonts.barlow(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 100, 100, 100),
                    ),
                    icon: Icons.help_outline,
                    press: () {},
                  ),
                  ProfileMenu(
                    text: "Cerrar Sesión",
                    textStyle: GoogleFonts.barlow(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 100, 100, 100),
                    ),
                    icon: Icons.logout_outlined,
                    press: () {
                      logout();
                    },
                  ),
                  ProfileMenu(
                    text: "Eliminar Cuenta",
                    textStyle: GoogleFonts.barlow(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 100, 100, 100),
                    ),
                    icon: Icons.delete_outline,
                    press: () {
                      delete();
                    },
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
            child: Material(
              color: Colors.transparent,
              child: InkResponse(
                radius: 28,
                onTap: () {
                  print("CLICK CÁMARA");
                  onPressed();
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 42, 79, 114),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserName extends StatelessWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Nombre Usuario',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 42, 79, 114),
          ),
          textAlign: TextAlign.center,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_add_outlined,
                  color: Color.fromARGB(255, 100, 100, 100),
                ),
                const SizedBox(width: 15),
                const Text(
                  '+ 100',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                ),
              ],
            ),
            const Text(
              'seguidores',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ],
        ),
        const SizedBox(width: 25),
        Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_add_outlined,
                  color: Color.fromARGB(255, 100, 100, 100),
                ),
                const SizedBox(width: 15),
                const Text(
                  '+ 150',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                ),
              ],
            ),
            const Text(
              'siguiendo',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ],
        ),
        const SizedBox(width: 25),
        Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_dining,
                  color: Color.fromARGB(255, 100, 100, 100),
                ),
                const SizedBox(width: 15),
                const Text(
                  '+ 15',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 100, 100, 100),
                  ),
                ),
              ],
            ),
            const Text(
              'recetas',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    this.textStyle,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final TextStyle? textStyle;
  final IconData icon;
  final VoidCallback? press;

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
                style: textStyle ?? const TextStyle(color: Color(0xFF757575)),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
