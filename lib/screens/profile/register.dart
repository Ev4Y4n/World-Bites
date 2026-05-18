import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/layout/nav_bar.dart';
import 'package:flutter_application_1/screens/profile/login.dart';
import 'package:flutter_application_1/screens/transition.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/firebase_error_handler.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  style: GoogleFonts.arbutusSlab(
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'Bites',
                  style: GoogleFonts.barlow(
                    fontSize: 30,
                    color: Colors.white,
                  ),
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
                'assets/images/fondo_titulo_v2.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 230,
            child: SafeArea(
              top: false,
              child: Image.asset(
                'assets/images/tenedor_2.png',
                width: 250,
                height: 250,
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
  final TextEditingController controllerUserName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String errorMessage = "";
  bool isLoading = false;

  @override
  void dispose() {
    controllerUserName.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  Future<void> register() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      if (_formKey.currentState!.validate()) {
        await authService.value.createAccount(
          userName: controllerUserName.text.trim(),
          email: controllerEmail.text.trim(),
          password: controllerPassword.text.trim(),
        );

        if (!mounted) return;

        loadTransition();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = FirebaseErrorHandler.getMessage(e);
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error inesperado";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void loginScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LogIn()),
    );
  }

  void loadTransition() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Transition()),
    );
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

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 42, 79, 114),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: controllerUserName,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_box),
                    labelText: 'Nombre Usuario *',
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
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 42, 79, 114),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            register();
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('REGISTRAR'),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta?'),
                    TextButton(
                      onPressed: loginScreen,
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