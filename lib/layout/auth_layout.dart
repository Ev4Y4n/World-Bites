import 'package:flutter/material.dart';
import 'package:flutter_application_1/layout/app_loading.dart';
import 'package:flutter_application_1/screens/category.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/profile/register.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class AuthLayout extends StatefulWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const AppLoadingPage();
            } else if (snapshot.hasData) {
              widget = const MainScreen();
            } else {
              widget = pageIfNotConnected ?? const Register();
            }
            return widget;
          },
        );
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
