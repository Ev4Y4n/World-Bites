import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
  static String getMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No existe una cuenta con este correo';

      case 'wrong-password':
        return 'La contraseña es incorrecta';

      case 'invalid-email':
        return 'El correo no es válido';

      case 'invalid-credential':
        return 'Correo o contraseña incorrectos';

      case 'too-many-requests':
        return 'Demasiados intentos, inténtalo más tarde';

      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';

      case 'network-request-failed':
        return 'Sin conexión a internet';

      default:
        return 'Error al iniciar sesión';
    }
  }
}