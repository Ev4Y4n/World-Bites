import 'package:flutter/material.dart';

void login() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'World Bites';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          centerTitle: true
        ),
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
                    hintText: 'Nombre',
                    labelText: 'Nombre *',
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
                ElevatedButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      onPressed: () {},
                      child: const Text('REGISTRAR'),
                    ),


                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Aún no tienes cuenta?'),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      onPressed: () {},
                      child: const Text('Registrar'),
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
