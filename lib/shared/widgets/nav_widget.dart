import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavWidget extends StatelessWidget {

  final void Function()? onPressed;
  final bool isHomeActive;

  const NavWidget({super.key, required this.isHomeActive, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Stack(
        children: [
          _homeContainer(context),
          _settingsContainer(context),
          if (isHomeActive) _floatingButton(context),
        ],
      ),
    );
  }

  Widget _floatingButton(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: MediaQuery.of(context).size.width / 2 - 30,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.add, size: 40, color: Colors.black),
          style: IconButton.styleFrom(padding: EdgeInsets.zero),
        ),
      ),
    );
  }

  Widget _homeContainer(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          color: isHomeActive ? Color.fromARGB(255, 0, 217, 255) : Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
        ),
        child:
            isHomeActive
                ? Icon(Icons.home, color: Colors.black, size: 30)
                : IconButton(
                  onPressed: () {
                    context.go('/categories');
                  },
                  icon: Icon(Icons.home, color: Colors.black, size: 30),
                ),
      ),
    );
  }

  Widget _settingsContainer(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: MediaQuery.of(context).size.width / 2,
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          color: isHomeActive ? Colors.white : Color.fromARGB(255, 0, 217, 255),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
        ),
        child:
            isHomeActive
                ? IconButton(
                  onPressed: () {
                    context.go('/categories/settings');
                  },
                  icon: Icon(Icons.settings, color: Colors.black, size: 30),
                )
                : Icon(Icons.settings, color: Colors.black, size: 30),
      ),
    );
  }
}
