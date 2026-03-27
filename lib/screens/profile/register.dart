import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/profile/login.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 110,
        title: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'World\n',
                  style: GoogleFonts.arbutusSlab(fontSize: 35, color: Colors.white) ,
                ),
                TextSpan(
                  text: 'Bites',
                  style: GoogleFonts.barlow(fontSize: 30, color: Colors.white),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Image.asset(
                'assets/images/fondo_titulo.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: const MyCustomForm(),
          ),
        ],
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  String errorMessage = "";
  final _formKey = GlobalKey<FormState>();

  Future<void> register() async {
    try {
      await authService.value.createAccount(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text.trim(),
      );
      print('Usuario registrado');
      loginScreen();
      setState(() {
        errorMessage = '';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Ha habido un error';
      });
    }
  }

  void loginScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => const LogIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  '"Descubre culturas, sabores y recetas únicas."',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(fontSize: 20),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF92B0AC),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: controllerEmail,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.mail),
                    labelText: 'Correo *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo no puede estar vacío';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: controllerPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Contraseña *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo no puede estar vacío';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                Text(errorMessage, style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF92B0AC),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      register();
                    }
                  },
                  child: const Text('REGISTRAR'),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta?'),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF92B0AC),
                        textStyle: GoogleFonts.barlow(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        loginScreen();
                      },
                      child: const Text('INICIAR SESIÓN'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
