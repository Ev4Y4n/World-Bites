import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/profile/login.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('World Bites'), centerTitle: true),
      body: const MyCustomForm(),
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

  void loginScreen(){
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
                const Text(
                  'Descubre culturas, sabores y recetas únicas.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Registrar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                      onPressed: () {
                        loginScreen();
                      },
                      child: const Text('Inicia Sesión'),
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
