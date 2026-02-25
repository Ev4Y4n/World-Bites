import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/profile/register.dart';
import 'package:flutter_application_1/screens/profile/reset_password.dart';
import 'package:flutter_application_1/services/auth_service.dart';

void login() => runApp(const LogIn());

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'World Bites';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle), centerTitle: true),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerEmail = TextEditingController();
    final TextEditingController controllerPassword = TextEditingController();
    String errorMessage = "";

    void enterApp() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (context) => const MainScreen()));
    }

    void registerScreen(){
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (context) => const Register()));
    }

    void resetPassword(){
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (context) => const ResetPassword()));
    }

    void login() async {
      try {
        await authService.value.signIn(
          email: controllerEmail.text,
          password: controllerPassword.text,
        );
        enterApp();
        setState(() {
          errorMessage = '';
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message ?? 'Algo salió mal. Vuelve a intentarlo';
        });
      }
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Tu próxima aventura culinaria te espera',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Email',
                    labelText: 'Email *',
                  ),
                  onSaved: (String? value) {},
                  validator: (String? value) {
                    return (value != null)
                        ? 'Este campo no puede estar vacío'
                        : null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    hintText: 'Contraseña',
                    labelText: 'Contraseña *',
                  ),
                  onSaved: (String? value) {},
                  validator: (String? value) {
                    return (value != null)
                        ? 'Este campo no puede estar vacío'
                        : null;
                  },
                ),
                const SizedBox(height: 10),

                Text(errorMessage, style: const TextStyle(color: Colors.red)),
                
                const SizedBox(height: 10),
                ElevatedButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: () {
                    login();
                  },
                  child: const Text('INICIAR SESIÓN'),
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Aún no tienes cuenta?'),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      onPressed: () {
                        registerScreen();
                      },
                      child: const Text('Registrar'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Has olvidado tu contraseña?'),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      onPressed: () {
                        resetPassword();
                      },
                      child: const Text('CAMBIAR CONTRASEÑA'),
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
