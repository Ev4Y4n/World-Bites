import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommingSoon extends StatefulWidget {
  const CommingSoon({super.key});

  @override
  State<CommingSoon> createState() => _CommingSoonState();
}

class _CommingSoonState extends State<CommingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 79, 114),
      body: Stack(
        children: [
          //Imagenes del fondo
          Positioned(
            top: -50,
            left: 220,
            child: Image.asset('assets/images/tacos.png', width: 250),
          ),
          Positioned(
            top: 0,
            left: 50,
            child: Transform.rotate(
              angle: -0.2,
              child: Image.asset(
                'assets/images/brochetas_pollo.png',
                width: 100,
              ),
            ),
          ),
          Positioned(
            top: 660,
            right: 220,
            child: Image.asset('assets/images/paella.png', width: 250),
          ),
          Positioned(
            top: 620,
            left: 240,
            child: Transform.rotate(
              angle: 2.0,
              child: Image.asset(
                'assets/images/tenedor_1.png',
                width: 200,
              ),
            ),
          ),

          //Botón volver
          Positioned(
            top: 50,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          //Texto (SIEMPRE encima)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, -100),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'World\n',
                          style: GoogleFonts.arbutusSlab(
                            fontSize: 60,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Bites',
                          style: GoogleFonts.barlow(
                            fontSize: 45,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Transform.translate(
                  offset: const Offset(0, -110),
                  child: Text(
                    'PRÓXIMAMENTE',
                    style: GoogleFonts.barlow(
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -80),
                  child: Text(
                    'Estamos cocinando una experiencia increíble',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Text(
                    'Muy pronto',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.barlow(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
