import 'package:flutter/material.dart';
import 'package:proyecto_final_flutter/controllers/login_controller.dart';

class LoginIngresarDatosScreen extends StatefulWidget {
  const LoginIngresarDatosScreen({super.key});

  @override
  State<LoginIngresarDatosScreen> createState() => _LoginIngresarDatosScreenState();
}

class _LoginIngresarDatosScreenState extends State<LoginIngresarDatosScreen> {
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  
  final LoginController loginController = LoginController();

  @override
  void dispose() {
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 40, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(37, 40, 255, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                const Padding(
                  padding: EdgeInsets.only(left: 50.0),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 25),
            
                Container(
                  padding: const EdgeInsets.all(50.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: correoController,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: contrasenaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Color.fromRGBO(37, 40, 255, 1),
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          loginController.iniciarSesion(
                            correoController.text.trim(),
                            contrasenaController.text.trim(),
                          );
                        },
                    
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(37, 40, 255, 1),
                          padding: const EdgeInsets.symmetric(horizontal: 106, vertical: 15),
                        ),

                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 319),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes una cuenta?',
                            style: TextStyle(
                              color: Color.fromRGBO(115, 115, 117, 1),
                              fontSize: 14,
                            ),
                          ),
                      
                          TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, '/register_screen');
                            },
                            child: const Text(
                              'Registrarse',
                              style: TextStyle(
                                color: Color.fromRGBO(37, 40, 255, 1),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
