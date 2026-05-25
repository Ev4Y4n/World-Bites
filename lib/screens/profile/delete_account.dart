import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  String errorMessage = "";
  bool accountDeleted = false;
  bool isLoading = false;

  void deleteAccount() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    try {
      await authService.value.deleteAccount(
        email: controllerEmail.text.trim(),
        password: controllerPassword.text.trim(),
      );

      setState(() {
        errorMessage = "";
        accountDeleted = true;
      });
      
      // Opcional: Redirigir al login después de unos segundos
      // Future.delayed(const Duration(seconds: 2), () => Navigator.of(context).pop());
      
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Algo ha ido mal. Vuelve a intentarlo";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 110,
        // BOTÓN VOLVER ATRÁS CON TU DISEÑO CIRCULAR
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(136, 97, 87, 87),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
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
      body: Stack(
        children: [
          // Imagen de fondo azul superior
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
          // Imagen del tenedor decorativa
          Positioned(
            top: 0,
            left: 230,
            right: 0,
            child: Image.asset(
              'assets/images/tenedor_2.png',
              width: 250,
              height: 250,
            ),
          ),
          // Contenido del formulario
          Padding(
            padding: const EdgeInsets.only(top: 220),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Borrar Cuenta',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 42, 79, 114),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Por seguridad, introduce tus credenciales para confirmar la eliminación definitiva.",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 30),

                      // Campo Email
                      TextFormField(
                        controller: controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.mail_outline),
                          labelText: 'Correo electrónico *',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Introduce tu correo";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Campo Password
                      TextFormField(
                        controller: controllerPassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock_outline),
                          labelText: 'Contraseña *',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Introduce tu contraseña";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Gestión de mensajes
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (accountDeleted)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Cuenta eliminada con éxito.",
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),

                      const SizedBox(height: 30),

                      // Botón de acción principal
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 42, 79, 114),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  deleteAccount();
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'BORRAR MI CUENTA',
                                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
                              ),
                      ),
                      const SizedBox(height: 20),
                    ],
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