import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class MarqueeStrip extends StatefulWidget {
  const MarqueeStrip({super.key});

  @override
  State<MarqueeStrip> createState() => _MarqueeStripState();
}

class _MarqueeStripState extends State<MarqueeStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  final List<String> _items = [
    'Branding', 'Web Design', 'App Development', '3D Solutions', 'AI Agent',
    'Motion Design', 'UI/UX', 'AI Agent', 'Branding', 'Web Design',
    'App Development', '3D Solutions', 'Motion Design', 'UI/UX',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _anim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color and decoration merged — no conflict
      decoration: const BoxDecoration(
        color: AppColors.black,
        border: Border.symmetric(
          horizontal: BorderSide(color: Color(0xFF1A1A1A), width: 1),
        ),
      ),
      height: 52,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          return LayoutBuilder(
            builder: (context, constraints) {
              const itemWidth = 180.0;
              final totalWidth = _items.length * itemWidth;
              final offset = -(_anim.value * totalWidth / 2);

              return Stack(
                children: [
                  Positioned(
                    left: offset,
                    top: 0,
                    bottom: 0,
                    width: totalWidth * 2,
                    child: Row(
                      children: List.generate(_items.length * 2, (i) {
                        final label = _items[i % _items.length];
                        return SizedBox(
                          width: itemWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                label.toUpperCase(),
                                style: GoogleFonts.syne(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '✦',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}