import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  final String _text;
  final Color _textColor;
  final Color _backgroundColor;
  final Color? _borderColor;
  final void Function() _onPressed;

  const PrimaryButton({
    super.key,
    required text,
    required textColor,
    required backgroundColor,
    required onPressed,
    Color? borderColor,
  }) : _text = text,
       _textColor = textColor,
       _backgroundColor = backgroundColor,
       _borderColor = borderColor,
       _onPressed = onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: TextButton(
        onPressed: _onPressed,
        style: TextButton.styleFrom(
          backgroundColor: _backgroundColor,
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: _borderColor != null ? BorderSide(color: _borderColor) : BorderSide.none,
          ),
        ),
        child: Text(_text, style: GoogleFonts.merriweather(color: _textColor, fontSize: 32)),
      ),
    );
  }
}
