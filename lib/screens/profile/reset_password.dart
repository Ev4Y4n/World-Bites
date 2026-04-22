import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile/register.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 110,
        centerTitle: true,
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
      ),
      body: Stack(
        children: [
          // Fondo header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/fondo_titulo_v2.png',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),

          // Imagen burrito
          Positioned(
            top: -10,
            left: 0,
            right: 220,
            child: Image.asset(
              'assets/images/burrito.png',
              width: 170,
              height: 170,
            ),
          ),

          // Imagen tenedor pollo
          Positioned(
            top: 50,
            left: 250,
            right: 0,
            child: Image.asset(
              'assets/images/tenedor_1.png',
              width: 170,
              height: 170,
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
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final TextEditingController controllerEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = "";
  bool emailSent = false;

  void resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await authService.value.resetPassword(email: controllerEmail.text.trim());
      setState(() {
        errorMessage = "";
        emailSent = true;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Algo ha ido mal. Vuelve a intentarlo";
      });
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    super.dispose();
  }

  void registerScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const Register()));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 120, 
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ajusta el tamaño del Column al contenido
              children: [
                Text(
                  '¿Has olvidado tu contraseña?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Introduce un correo electrónico y te mandamos el link para resetearlo',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlow(fontSize: 15),
                ),

                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Cambiar contraseña',
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
                      return "Introduce un correo electrónico";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),

                if (emailSent)
                  const Text(
                    "Correo enviado! Revisa tu bandeja de entrada.",
                    style: TextStyle(color: Colors.green),
                  ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 42, 79, 114),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: resetPassword,
                  child: const Text("RESTABLECER CONTRASEÑA"),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  final String title, text;

  const WelcomeText({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
