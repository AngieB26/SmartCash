import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      throw Exception('Error inesperado durante el registro');
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      throw Exception('Error inesperado durante el inicio de sesión');
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final googleSignIn = GoogleSignIn(); 

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: No se pudo obtener la información de autenticación de Google'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: No se pudo crear la sesión del usuario'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return null;
      }

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home_screen');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '¡Bienvenido/a ${userCredential.user?.displayName ?? 'Usuario'}!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de autenticación: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        String errorMessage = 'Error inesperado';
        if (e.toString().contains('Null check')) {
          errorMessage = 'Error de autenticación: Información incompleta de Google';
        } else {
          errorMessage = 'Error inesperado: ${e.toString()}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }

      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        GoogleSignIn().signOut(),
      ]);
    } catch (_) {
      throw Exception('Error al cerrar sesión');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      throw Exception('Error al enviar email de restablecimiento');
    }
  }

  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (_) {
      throw Exception('Error al enviar verificación de email');
    }
  }

  Future<void> reloadUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
    } catch (_) {
      throw Exception('Error al recargar datos del usuario');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      await user.delete();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Error al eliminar la cuenta: ${e.toString()}');
    }
  }
}
