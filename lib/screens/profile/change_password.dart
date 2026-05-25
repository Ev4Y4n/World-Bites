import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerCurrentPassword = TextEditingController();
  final TextEditingController controllerNewPassword = TextEditingController();
  String errorMessage = "";

  void updatePassword() async {
    try {
      await authService.value.resetPasswordFromCurrentPassword(
        currentPassword: controllerCurrentPassword.text,
        newPassword: controllerNewPassword.text,
        email: controllerEmail.text,
      );
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully")),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Algo salió mal. Vuelve a intentarlo';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack( // Usamos Stack para asegurar que el botón esté por encima de todo
        children: [
          LogoWithTitle(
            title: "Change Password",
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controllerCurrentPassword,
                      obscureText: true,
                      validator: (value) => value!.isEmpty ? "Enter current password" : null,
                      decoration: const InputDecoration(
                        hintText: 'Current Password',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controllerNewPassword,
                      obscureText: true,
                      validator: (value) => value!.length < 6 ? "Min 6 characters" : null,
                      decoration: const InputDecoration(
                        hintText: 'New Password',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (errorMessage.isNotEmpty)
                      Text(errorMessage, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updatePassword();
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF00BF6D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const StadiumBorder(),
                ),
                child: const Text("Change Password"),
              ),
            ],
          ),
          // BOTÓN DE RETROCESO POSICIONADO MANUALMENTE
          Positioned(
            top: 50, // Ajusta según el notch de tu móvil
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(136, 97, 87, 87),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogoWithTitle extends StatelessWidget {
  final String title, subText;
  final List<Widget> children;

  const LogoWithTitle({
    super.key,
    required this.title,
    this.subText = '',
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 100), 
          Image.network(
            "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
            height: 100,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (subText.isNotEmpty)
            Text(
              subText,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}