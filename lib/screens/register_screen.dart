import 'package:flutter/material.dart';
import 'package:proyecto_final_flutter/controllers/register_login_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  final confirmarController = TextEditingController();

  final RegisterLoginController controller = RegisterLoginController();
  bool _isLoading = false;

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    confirmarController.dispose();
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
                Padding(
                  padding: EdgeInsets.only(left: 50.0),
                  child: Text(
                    'Registrarse',
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
                      const Text(
                        'Bienvenido a la SmartCash',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(115, 115, 117, 1),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: nombreController,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),),
                        ),
                      ),
                  
                      const SizedBox(height: 20),

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

                      TextField(
                        controller: confirmarController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _isLoading ? null : () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await controller.registrarUsuario(
                            nombre: nombreController.text.trim(),
                            correo: correoController.text.trim(),
                            contrasena: contrasenaController.text,
                            confirmarContrasena: confirmarController.text,
                          );
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                    
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(37, 40, 255, 1),
                          padding: const EdgeInsets.symmetric(horizontal: 114, vertical: 15),
                          disabledBackgroundColor: Colors.grey,
                        ),

                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Registrarse',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),

                      const SizedBox(height: 168),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿Ya tienes una cuenta?',
                            style: TextStyle(
                              color: Color.fromRGBO(115, 115, 117, 1),
                              fontSize: 14,
                            ),
                          ),
                      
                          TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, '/login_ingresar_datos_screen');
                            },
                            child: const Text(
                              'Iniciar Sesión',
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