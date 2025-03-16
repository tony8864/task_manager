import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AbstractSettingWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const AbstractSettingWidget({super.key, required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(children: [_leadingAndTitle(), _divider()]),
    );
  }

  Widget _leadingAndTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.merriweather(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 1, color: Colors.grey);
  }
}
