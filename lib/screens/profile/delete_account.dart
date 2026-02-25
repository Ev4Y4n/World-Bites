import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String errorMessage = "";
  bool emailSent = false;

  void deleteAccount() async {
    try {
      await authService.value.deleteAccount(email: controllerEmail.text, password: controllerPassword.text)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Borrar Cuenta"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const WelcomeText(
              title: "¿Estás seguro de que quieres eliminar la cuenta?",
              text: "Una vez eliminado, ya no se podrá recuperar",
            ),
            const SizedBox(height: 16),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controllerEmail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Introduce un correo electrónico";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email Address",
                      labelText: "Correo electrónico",
                      icon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error or success message
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (emailSent)
                    const Text(
                      "Cuenta eliminada correctamente",
                      style: TextStyle(color: Colors.green),
                    ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22A45D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: deleteAccount,
                    child: const Text("Reset password"),
                  ),
                ],
              ),
            ),
          ],
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
