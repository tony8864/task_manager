import 'package:flutter/material.dart';
import 'package:task_manager/core/colors/app_colors.dart';
import 'package:task_manager/view/settings/settings_view.dart';

class NavWidget extends StatelessWidget {
  final void Function()? onPressed;
  final bool isHomeActive;
  final bool isFloatingButtonActive;

  const NavWidget({
    super.key,
    required this.isHomeActive,

    required this.isFloatingButtonActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Stack(
        children: [
          _homeContainer(context),
          _settingsContainer(context),
          if (isFloatingButtonActive) _floatingButton(context),
        ],
      ),
    );
  }

  Widget _floatingButton(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: MediaQuery.of(context).size.width / 2 - 30,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 138, 138, 138).withValues(alpha: 0.5),
              spreadRadius: 7,
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
          color: isHomeActive ? AppColors.blue : Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
        ),
        child:
            isHomeActive
                ? Icon(Icons.home, color: Colors.black, size: 30)
                : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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
          color: isHomeActive ? Colors.white : AppColors.blue,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
        ),
        child:
            isHomeActive
                ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsView()),
                    );
                  },
                  icon: Icon(Icons.settings, color: Colors.black, size: 30),
                )
                : Icon(Icons.settings, color: Colors.black, size: 30),
      ),
    );
  }
}
