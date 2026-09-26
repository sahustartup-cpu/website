import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';

class HeroSection extends StatelessWidget {
  final Map<String, dynamic>? hero;
  final VoidCallback onStartProject;

  const HeroSection({super.key, this.hero, required this.onStartProject});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final tagline = hero?['tagline'] as String? ??
        'We build websites, apps & AI solutions\nthat turn visitors into customers.';
    final imageUrl = hero?['image_url'] as String?;

    return SizedBox(
      width: double.infinity,
      height: h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image — no overlay
          if (imageUrl != null)
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
              placeholder: (_, __) => Container(color: AppColors.black),
              errorWidget: (_, __, ___) => Container(color: AppColors.black),
            )
          else
            Container(color: AppColors.black),

          // MANOJ — animate: fade + slide up + slight scale
          Positioned(
            left: 40,
            bottom: 320,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // MANOJ — slides in from left
                Text('MANOJ',
                    style: GoogleFonts.syne(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: w * 0.10,
                      letterSpacing: -3,
                      height: 1.0,
                    ))
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 700.ms)
                    .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic)
                    .then()
                    .shimmer(
                      delay: 800.ms,
                      duration: 1200.ms,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),

                // SAHU — slides in from left slightly later
                Text('SAHU',
                    style: GoogleFonts.syne(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: w * 0.09,
                      letterSpacing: -3,
                      height: 1.0,
                    ))
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 700.ms)
                    .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic)
                    .then()
                    .shimmer(
                      delay: 600.ms,
                      duration: 1200.ms,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
              ],
            ),
          ),

          // Tagline — fades in from bottom separately
          Positioned(
            left: 40,
            bottom: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tagline,
                  style: GoogleFonts.syne(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: w > 800 ? 28 : 20,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onStartProject,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Hire Me Today',
                              style: GoogleFonts.syne(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              )),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(delay: 800.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
          ),
        ],
      ),
    );
  }
}