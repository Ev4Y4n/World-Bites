import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/layout/nav_bar.dart';
import 'package:flutter_application_1/screens/profile/register.dart';
import 'package:flutter_application_1/screens/profile/reset_password.dart';
import 'package:flutter_application_1/screens/transition.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

void login() => runApp(const LogIn());

class LogIn extends StatelessWidget {
  const LogIn({super.key});

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
                'assets/images/fondo_titulo_v2.png',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Imagen tenedor pollo
          Positioned(
            top: 50,
            left: 230,
            right: 0,
            child: SafeArea(
              //se usa para evitar que el contenido se superponga con elementos del sistema, como la barra de estado o la barra de navegación en dispositivos móviles.
              top: false,
              child: Image.asset(
                'assets/images/tenedor_1.png',
                width: 180,
                height: 180,
              ),
            ),
          ),

          Padding(
            //Se usa para agregar espacio alrededor del widget MyCustomForm, en este caso, se agrega un espacio de 180 píxeles desde la parte superior.
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
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  String errorMessage = "";
  bool isLoading = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  void enterApp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NavBar()));
  }

  void registerScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const Register()));
  }

  void resetPassword() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ResetPassword()));
  }

  void loadTransition() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Transition()),
    );
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      await authService.value.signIn(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text.trim(),
      );

      if (!mounted) return;

      loadTransition();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Error al iniciar sesión";
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
                  '"Tu próxima aventura culinaria te espera"',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(fontSize: 20),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 42, 79, 114),
                    ),
                    textAlign: TextAlign.left,
                  ),
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

                Text(errorMessage, style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 42, 79, 114),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            loginUser();
                          }
                        },
                  child:
                      isLoading //Se usa para mostrar un indicador de carga mientras se espera la respuesta de Firebase
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('INICIAR SESIÓN'),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Aún no tienes cuenta?',
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 42, 79, 114),
                        textStyle: GoogleFonts.barlow(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        registerScreen();
                      },
                      child: const Text('REGISTRAR'),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Has olvidado tu contraseña?',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 42, 79, 114),
                    textStyle: GoogleFonts.barlow(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: resetPassword,
                  child: const Text('CAMBIAR CONTRASEÑA'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
