import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class NotchNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;

  const NotchNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  State<NotchNavBar> createState() => _NotchNavBarState();
}

class _NotchNavBarState extends State<NotchNavBar> {
  late final NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController(index: widget.currentIndex);
  }

  @override
  void didUpdateWidget(covariant NotchNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _controller.jumpTo(widget.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      notchBottomBarController: _controller,
      color: const Color.fromARGB(255, 37, 40, 255),
      notchColor: Colors.white,
      showLabel: true,
      itemLabelStyle: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 255, 255, 255)),
      bottomBarItems: const [
        BottomBarItem(
          inActiveItem: Icon(Icons.home_filled, color: Color.fromARGB(255, 255, 255, 255)),
          activeItem: Icon(Icons.home_filled, color:  Color.fromARGB(255, 37, 40, 255)),
          itemLabel: 'Inicio',
        ),
        BottomBarItem(
          inActiveItem: Icon(Icons.calendar_today, color: Color.fromARGB(255, 255, 255, 255)),
          activeItem: Icon(Icons.calendar_today, color: Color.fromARGB(255, 37, 40, 255)),
          itemLabel: 'Plan',
        ),
        BottomBarItem(
          inActiveItem: Icon(Icons.bar_chart, color: Color.fromARGB(255, 255, 255, 255)),
          activeItem: Icon(Icons.bar_chart, color:  Color.fromARGB(255, 37, 40, 255)),
          itemLabel: 'Gráfico',
        ),
        BottomBarItem(
          inActiveItem: Icon(Icons.person, color: Color.fromARGB(255, 255, 255, 255)),
          activeItem: Icon(Icons.person, color:  Color.fromARGB(255, 37, 40, 255)),
          itemLabel: 'Cuenta',
        ),
      ],
      kIconSize: 24.0,
      kBottomRadius: 28.0,
      elevation: 1,
      bottomBarWidth: 500,
      showShadow: false,
      shadowElevation: 5,
      textOverflow: TextOverflow.visible,
      maxLine: 1,
      removeMargins: false,
      durationInMilliSeconds: 300,
      onTap: widget.onTabChange,
    );
  }
}
