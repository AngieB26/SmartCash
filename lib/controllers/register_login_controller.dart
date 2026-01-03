import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterLoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registrarUsuario({
    required String nombre,
    required String correo,
    required String contrasena,
    required String confirmarContrasena,
  }) async {
    if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty || confirmarContrasena.isEmpty) {
      _mostrarMensaje("Completa todos los campos.");
      return;
    }

    if (contrasena != confirmarContrasena) {
      _mostrarMensaje("Las contraseñas no coinciden.");
      return;
    }

    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      if (cred.user == null) {
        _mostrarMensaje("Error al crear el usuario. Intenta nuevamente.");
        return;
      }

      await _firestore.collection('usuarios').doc(cred.user!.uid).set({
        'nombre': nombre,
        'correo': correo,
        'uid': cred.user!.uid,
        'fecha_registro': Timestamp.now(),
      });

      _mostrarMensaje("Usuario registrado correctamente");
      Get.offAllNamed('/login_ingresar_datos_screen');

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _mostrarMensaje("Ese correo ya está en uso.");
      } else if (e.code == 'invalid-email') {
        _mostrarMensaje("Correo inválido.");
      } else if (e.code == 'weak-password') {
        _mostrarMensaje("Contraseña débil (mínimo 6 caracteres).");
      } else {
        _mostrarMensaje("Error: ${e.message}");
      }
    } catch (e) {
      _mostrarMensaje("Ocurrió un error inesperado.");
    }
  }

  void _mostrarMensaje(String mensaje) {
    Get.snackbar(
      'Mensaje',
      mensaje,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
