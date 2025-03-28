import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.9,
        height: screenHeight * 0.08,
        decoration: BoxDecoration(
          color: Color(0xFF5B1A90),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(text,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
