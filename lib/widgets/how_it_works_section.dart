import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final pad = w > 900 ? 80.0 : 24.0;

    final steps = [
      ('01', 'Discovery', 'We start with a thorough discussion to understand your vision, objectives, and specific challenges.'),
      ('02', 'Design & Build', 'I design and develop solutions iteratively, ensuring you get regular updates and feedback milestones.'),
      ('03', 'Launch & Scale', 'We launch carefully, monitor performance, and I provide ongoing support for your growth.'),
    ];

    return Container(
      color: AppColors.black,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HOW WE WORK',
              style: GoogleFonts.dmSans(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              )),
          const SizedBox(height: 16),
          Text('A Simple Process\nFor Big Results',
              style: GoogleFonts.syne(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: w > 900 ? 52 : 36,
                letterSpacing: -1.5,
              )),
          const SizedBox(height: 60),

          // Steps grid
          MediaQuery.of(context).size.width > 800
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: steps.map((s) => Expanded(child: _stepCard(s))).toList(),
                )
              : Column(
                  children: steps.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _stepCard(s),
                  )).toList(),
                ),
        ],
      ),
    );
  }

  Widget _stepCard((String, String, String) s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.$1,
              style: GoogleFonts.syne(
                color: Colors.white.withValues(alpha: 0.2),
                fontWeight: FontWeight.w800,
                fontSize: 48,
              )),
          const SizedBox(height: 16),
          Text(s.$2,
              style: GoogleFonts.syne(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              )),
          const SizedBox(height: 12),
          Text(s.$3,
              style: GoogleFonts.dmSans(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 15,
                height: 1.6,
              )),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0);
  }
}
