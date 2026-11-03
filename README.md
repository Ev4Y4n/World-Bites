# World Bites

Aplicación multiplataforma de recetas del mundo desarrollada con **Flutter** y **Firebase**. Permite explorar recetas por país y categoría, guardar favoritos, crear tus propias recetas con foto y gestionar tu perfil de usuario.

> **Trabajo de Fin de Grado** del Ciclo Superior de Desarrollo de Aplicaciones Multiplataforma (CESUR). Versión **beta** creada para la entrega del proyecto.

## Trailer
https://github.com/user-attachments/assets/457cca37-bbdc-495b-bfbb-2a94a1ec487e


## Funcionalidades

- **Recetas por país y categoría:** 20 países en el selector, con recetas completas de **Italia** y **México**. El resto de países (Japón, India, Tailandia, España, Argentina, Armenia, Brasil, China, Francia, Alemania, Grecia, Indonesia, Marruecos, Perú, Corea del Sur, Suiza, Turquía y Estados Unidos) aparecen como "próximamente".
- **Explorar y buscar** recetas.
- **Favoritos:** guarda y quita recetas de tu lista.
- **Crear recetas propias**, con imagen subida a Firebase Storage, y borrarlas.
- **Cuentas de usuario:** registro, inicio de sesión, recuperación y cambio de contraseña, y eliminación de cuenta.
- **Perfil** con foto y nombre de usuario, y **perfil público** de otros usuarios.
- **Animación de introducción** y navegación inferior con barra curva.

## Tecnologías utilizadas

- **Flutter y Dart:** desarrollo de la aplicación móvil.
- **Firebase Authentication:** autenticación de usuarios.
- **Cloud Firestore:** almacenamiento y gestión de datos.
- **Firebase Storage:** almacenamiento de imágenes.
- **Provider:** gestión del estado de la aplicación.
- **Material 3, Google Fonts, Lottie y Curved Navigation Bar:** diseño de la interfaz, animaciones y navegación.
- **image_picker y cached_network_image:** selección y carga eficiente de imágenes.

## Estructura del proyecto

```
lib/
├── layout/        # Barra de navegación, tarjetas y layout de autenticación
├── providers/     # Estado global de la app (país seleccionado, navegación)
├── screens/       # Pantallas: inicio, explorar, recetas, perfil, favoritos...
│   ├── profile/   # Login, registro, contraseña, perfil público
│   └── ui_elements/
├── services/      # Acceso a Firebase (auth, base de datos, recetas)
└── main.dart
assets/
├── images/ · animations/
└── json/          # Recetas y categorías de ejemplo (Italia y México)
```

## Cómo ejecutarlo

### Requisitos
- Flutter con Dart `^3.10.8`
- Un proyecto de Firebase propio

### Pasos
1. Clona el repositorio:
   ```bash
   git clone https://github.com/Ev4Y4n/World-Bites.git
   cd World-Bites
   ```
2. Instala las dependencias:
   ```bash
   flutter pub get
   ```
3. Conecta tu proyecto de Firebase con [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/):
   ```bash
   flutterfire configure
   ```
   Activa en tu consola de Firebase **Authentication** (email y contraseña), **Firestore** y **Storage**.
4. Carga las recetas de ejemplo en Firestore a partir de los JSON de `assets/json/` (ver `lib/upload_recipes.dart`).
5. Ejecuta la app:
   ```bash
   flutter run
   ```
   
## Estado del proyecto y próximos pasos

Esta es una **versión beta** entregada como TFG, con margen para seguir mejorándola en el futuro. Líneas de trabajo pendientes:

- Asistente de chat (el botón existe en la interfaz y lleva a una pantalla de "próximamente")
- Recetas del resto de países (ya incluidos en el selector, pendientes de contenido)
- Sección de seguidos en el perfil
- Tests y reglas de seguridad de Firestore por usuario

Como el backend usa Firebase, para ejecutarla necesitas tu propio proyecto de Firebase.

## Autoría

Proyecto de TFG del Ciclo Superior de Desarrollo de Aplicaciones Multiplataforma (CESUR).
Desarrollado por **Eva Alaverdyan**: diseño de la interfaz, programación de la app, integración con Firebase (autenticación, Firestore y Storage) y carga de las recetas de ejemplo.

[GitHub](https://github.com/Ev4Y4n) · [LinkedIn](https://www.linkedin.com/in/eva-alaverdyan)
