import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';

class TrustBar extends StatelessWidget {
  const TrustBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Text('TRUSTED TECHNOLOGY STACK',
              style: GoogleFonts.dmSans(
                color: AppColors.gray,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              )),
          const SizedBox(height: 24),
          Wrap(
            spacing: 40,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _tech('Flutter'),
              _tech('Supabase'),
              _tech('OpenAI'),
              _tech('Figma'),
              _tech('Next.js'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tech(String name) => Text(name,
      style: GoogleFonts.syne(
        color: AppColors.black,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      )).animate().fadeIn(duration: 500.ms);
}
