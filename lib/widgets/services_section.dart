import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';

class ServicesSection extends StatelessWidget {
  final VoidCallback onStartProject;
  const ServicesSection({super.key, required this.onStartProject});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;
    final pad = isWide ? 80.0 : 24.0;

    final services = [
      _ServiceItem(
        icon: Icons.language_rounded,
        title: 'Web Design & Development',
        desc: 'Fast, conversion-focused websites and web apps built with modern frameworks. Pixel-perfect UI, responsive across all devices.',
        tags: ['Flutter Web', 'React', 'Next.js', 'Supabase'],
        accent: const Color(0xFF4F8EF7),
      ),
      _ServiceItem(
        icon: Icons.phone_iphone_rounded,
        title: 'Mobile App Development',
        desc: 'Cross-platform iOS & Android apps that feel native. Built with Flutter for speed, performance, and beautiful UX.',
        tags: ['Flutter', 'iOS', 'Android', 'Firebase'],
        accent: const Color(0xFF34C759),
      ),
      _ServiceItem(
        icon: Icons.auto_awesome_rounded,
        title: 'AI Agent Development',
        desc: 'Custom AI-powered workflows, chatbots, and automation agents that save your team hours every week.',
        tags: ['OpenAI', 'LangChain', 'Python', 'Claude API'],
        accent: const Color(0xFFAF52DE),
      ),
      _ServiceItem(
        icon: Icons.palette_rounded,
        title: 'Branding & Identity',
        desc: 'Logos, color systems, typography, and brand guidelines that make you look like a \$1M company from day one.',
        tags: ['Logo Design', 'Brand Kit', 'Figma', 'Style Guide'],
        accent: const Color(0xFFFF9F0A),
      ),
    ];

    return Container(
      color: AppColors.lightBg,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SERVICES',
                      style: GoogleFonts.dmSans(
                        color: AppColors.gray,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(duration: 500.ms),
                    const SizedBox(height: 16),
                    Text(
                      'What I Build\nFor You',
                      style: GoogleFonts.syne(
                        color: AppColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: isWide ? 64 : 40,
                        letterSpacing: -2,
                        height: 0.95,
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 600.ms),
                  ],
                ),
              ),
              if (isWide) ...[
                const SizedBox(width: 40),
                Text(
                  'Every service is designed to\ndeliver measurable results.',
                  style: GoogleFonts.dmSans(
                    color: AppColors.gray,
                    fontSize: 15,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
              ],
            ],
          ),

          const SizedBox(height: 60),

          // Cards
          isWide ? _wideGrid(services) : _narrowList(services),

          const SizedBox(height: 60),

          // Bottom CTA
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onStartProject,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start a Project',
                        style: GoogleFonts.syne(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
        ],
      ),
    );
  }

  Widget _wideGrid(List<_ServiceItem> items) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ServiceCard(item: items[0], delay: 0)),
            const SizedBox(width: 20),
            Expanded(child: _ServiceCard(item: items[1], delay: 80)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ServiceCard(item: items[2], delay: 160)),
            const SizedBox(width: 20),
            Expanded(child: _ServiceCard(item: items[3], delay: 240)),
          ],
        ),
      ],
    );
  }

  Widget _narrowList(List<_ServiceItem> items) {
    return Column(
      children: items.asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _ServiceCard(item: e.value, delay: e.key * 80),
      )).toList(),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String title;
  final String desc;
  final List<String> tags;
  final Color accent;
  const _ServiceItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.tags,
    required this.accent,
  });
}

class _ServiceCard extends StatefulWidget {
  final _ServiceItem item;
  final int delay;
  const _ServiceCard({required this.item, required this.delay});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? Colors.transparent
                : Colors.black.withValues(alpha: 0.07),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _hovered
                    ? item.accent.withValues(alpha: 0.15)
                    : item.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon,
                  color: item.accent, size: 24),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              item.title,
              style: GoogleFonts.syne(
                color: _hovered ? Colors.white : AppColors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              item.desc,
              style: GoogleFonts.dmSans(
                color: _hovered
                    ? Colors.white.withValues(alpha: 0.55)
                    : AppColors.gray,
                fontSize: 14,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 20),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _hovered
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppColors.lightBg,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.dmSans(
                    color: _hovered
                        ? Colors.white.withValues(alpha: 0.5)
                        : AppColors.gray,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.delay))
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
