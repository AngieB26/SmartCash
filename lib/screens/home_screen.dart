import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final_flutter/widgets/bottom_nav_bar.dart';
import 'package:proyecto_final_flutter/widgets/home.dart';
import 'package:proyecto_final_flutter/widgets/plan.dart';
import 'package:proyecto_final_flutter/widgets/graph.dart';
import 'package:proyecto_final_flutter/widgets/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotchBottomBarController _controller;
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController(index: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabChange(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _controller.jumpTo(index);
    }
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const Home();
      case 1:
        return const Plan();
      case 2:
        return const GraphScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _getCurrentScreen(),
      bottomNavigationBar: NotchNavBar(
        currentIndex: _currentIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}

