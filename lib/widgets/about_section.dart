import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;
    final pad = isWide ? 80.0 : 24.0;

    return Container(
      color: AppColors.black,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 100),
      child: isWide ? _wideLayout(context) : _narrowLayout(context),
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left — photo placeholder
        Expanded(
          flex: 4,
          child: _photoBlock(),
        ),
        const SizedBox(width: 80),
        // Right — text content
        Expanded(
          flex: 6,
          child: _textContent(context),
        ),
      ],
    );
  }

  Widget _narrowLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textContent(context),
        const SizedBox(height: 48),
        _photoBlock(),
      ],
    );
  }

  Widget _photoBlock() {
    return Container(
      height: 480,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Stack(
        children: [
          // Decorative corner marks
          Positioned(
            top: 24, left: 24,
            child: Text('✦',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.15),
                  fontSize: 18,
                )),
          ),
          Positioned(
            bottom: 24, right: 24,
            child: Text('✦',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.15),
                  fontSize: 18,
                )),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar placeholder
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 2,
                    ),
                    color: const Color(0xFF1E1E1E),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Photo coming soon',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.2),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Bottom tag
          Positioned(
            bottom: 24, left: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                'India → Worldwide',
                style: GoogleFonts.dmSans(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 700.ms)
        .slideX(begin: -0.1, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _textContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'ABOUT',
          style: GoogleFonts.dmSans(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(duration: 500.ms),

        const SizedBox(height: 20),

        // Headline
        RichText(
          text: TextSpan(
            style: GoogleFonts.syne(
              fontWeight: FontWeight.w800,
              fontSize: MediaQuery.of(context).size.width > 900 ? 52 : 36,
              letterSpacing: -2,
              height: 1.0,
            ),
            children: const [
              TextSpan(text: 'Hi, I\'m\n', style: TextStyle(color: Colors.white)),
              TextSpan(text: 'Manoj Sahu', style: TextStyle(color: Colors.white)),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 100.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 28),

        // Bio
        Text(
          'I\'m a full-stack designer and developer based in India, '
          'specializing in building digital products for startups and '
          'growing businesses across the US and worldwide.',
          style: GoogleFonts.dmSans(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 16,
            height: 1.75,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

        const SizedBox(height: 16),

        Text(
          'From brand identity and UI/UX design to full-scale web apps, '
          'mobile applications, and AI-powered solutions — I handle it all '
          'with the same attention to detail that US-based studios charge 5x more for.',
          style: GoogleFonts.dmSans(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 15,
            height: 1.75,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

        const SizedBox(height: 40),

        // Stats row
        _statsRow(),

        const SizedBox(height: 40),

        // CTA
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'See My Work',
                    style: GoogleFonts.syne(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
      ],
    );
  }

  Widget _statsRow() {
    final stats = [
      ('3+', 'Years\nExperience'),
      ('20+', 'Projects\nDelivered'),
      ('100%', 'Client\nSatisfaction'),
    ];

    return Row(
      children: stats.asMap().entries.map((e) {
        final i = e.key;
        final s = e.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < stats.length - 1 ? 20 : 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.$1,
                    style: GoogleFonts.syne(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.$2,
                    style: GoogleFonts.dmSans(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: Duration(milliseconds: 300 + i * 80))
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.1, end: 0),
        );
      }).toList(),
    );
  }
}
