import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_final_flutter/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });

      try {
        final doc = await _firestore.collection('usuarios').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _userData = doc.data();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String get _userName {
    if (_userData != null && _userData!['nombre'] != null) {
      return _userData!['nombre'];
    }
    return _user?.displayName ?? 'Usuario';
  }

  String get _userEmail {
    return _user?.email ?? 'correo@ejemplo.com';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color.fromRGBO(37, 40, 255, 1),
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            _userName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _userEmail,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          
          Expanded(
            child: ListView(
              children: [
                _buildSettingsSection(
                  title: 'Configuración',
                  items: [
                    _buildSettingsItem(
                      icon: Icons.palette,
                      title: 'Apariencia',
                      subtitle: 'Personaliza la app',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.dark_mode_rounded,
                      title: 'Modo oscuro',
                      subtitle: 'Automático',
                      onTap: () {},
                      trailing: Switch.adaptive(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                _buildSettingsSection(
                  title: 'Información',
                  items: [
                    _buildSettingsItem(
                      icon: Icons.info_rounded,
                      title: 'Acerca de',
                      subtitle: 'Más sobre SmartCash',
                      onTap: () {},
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                _buildSettingsSection(
                  title: 'Cuenta',
                  items: [
                    _buildSettingsItem(
                      icon: Icons.exit_to_app_rounded,
                      title: 'Cerrar sesión',
                      onTap: () async {
                        final confirm = await _showLogoutDialog(context);
                        if (confirm == true) {
                          await _authService.signOut();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/welcome_screen');
                          }
                        }
                      },
                    ),
                    _buildSettingsItem(
                      icon: CupertinoIcons.delete_solid,
                      title: 'Eliminar cuenta',
                      titleStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      onTap: () {
                        _showDeleteAccountDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    TextStyle? titleStyle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        child: Icon(
          icon,
          color: Colors.blue,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: titleStyle ?? const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text(
            '¿Estás seguro de que deseas cerrar sesión?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(37, 40, 255, 1),
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar cuenta'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer y se perderán todos tus datos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  if (_user != null) {
                    await _firestore.collection('usuarios').doc(_user!.uid).delete();
                    await _authService.deleteAccount();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/welcome_screen');
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al eliminar cuenta: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}