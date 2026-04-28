import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile/change_password.dart';
import 'package:flutter_application_1/screens/profile/delete_account.dart';
import 'package:flutter_application_1/screens/profile/register.dart';
import 'package:flutter_application_1/screens/profile/reset_password.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    File? selectedImage;
    final ImagePicker _picker = ImagePicker();

    Future getProfileImage() async {
      // Lógica para obtener la foto de perfil del usuario desde Firebase Storage
      var image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage = File(image.path);
        //setState(() {});
      }
    }

    Future<void> uploadProfileImage() async {
      // Lógica para subir la foto de perfil del usuario a Firebase Storage
      if (selectedImage != null) {
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          "UserProfileImages",
        );
        final UploadTask task = firebaseStorageRef.putFile(
          selectedImage!,
        ); // Subir la imagen a Firebase Storage
        var downloadurl = await (await task).ref
            .getDownloadURL(); // Obtener la URL
        Map<String, dynamic> addrecipe = {"Image": downloadurl};
        DatabaseMethods().addProfilePicture(
          FirebaseAuth.instance.currentUser!.uid,
          downloadurl,
        ); // Guardar la URL en la base de datos
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //Fondo
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

          //Avatar (foto + icono)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: const Center(child: ProfilePic()),
          ),

          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: const Center(child: UserName()),
          ),

          Positioned(
            top: 260,
            left: 0,
            right: 0,
            child: const Center(child: UserInfo()),
          ),

          //Contenido
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 330),
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
        ],
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
              "https://i.postimg.cc/0jqKB6mS/Profile-Image.png",
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                //Icono para cambiar foto de perfil
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color.fromARGB(255, 42, 79, 114),
                ),
                onPressed: () {},
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
          constraints:
              const BoxConstraints(), // Elimina el espacio alrededor del icono
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
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Text(
              'seguidores',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
              textAlign: TextAlign.center,
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
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Text(
              'siguiendo',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
              textAlign: TextAlign.center,
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
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Text(
              'recetas',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
              textAlign: TextAlign.center,
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
          foregroundColor: Color.fromARGB(255, 42, 79, 114),
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
              child: Icon(
                icon,
                color: const Color.fromARGB(255, 255, 255, 255),
                size: 20,
              ),
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
