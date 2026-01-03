import 'package:flutter/material.dart';
import 'package:proyecto_final_flutter/screens/home_screen.dart';
import 'package:proyecto_final_flutter/screens/login_ingresar_datos_screen.dart';
import 'package:proyecto_final_flutter/screens/login_screen.dart';
import 'package:proyecto_final_flutter/screens/register_screen.dart';
import 'package:proyecto_final_flutter/screens/welcome_screen.dart';
import 'package:proyecto_final_flutter/screens/forgot_password.dart';

Map<String, WidgetBuilder> routes() {
  return {
    '/welcome_screen': (context) => const WelcomeScreen(),
    '/login_screen': (context) => const LoginScreen(),
    '/login_ingresar_datos_screen': (context) => const LoginIngresarDatosScreen(),
    '/register_screen': (context) => const RegisterScreen(),
    '/home_screen': (context) => const HomeScreen(),
    '/forgot_password': (context) => const ForgotPasswordScreen(),
  };
}
