import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight? fontWeight;
  final double fontSize;
  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.fontWeight,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
