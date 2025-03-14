import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Task Manager',
          style: GoogleFonts.merriweather(
            fontSize: 40,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text('Manage your apps easily.', style: GoogleFonts.merriweather(fontSize: 20, color: Colors.white)),
      ],
    );
  }
}
