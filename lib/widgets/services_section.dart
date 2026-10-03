import 'package:flutter/material.dart';
import 'fx/fx_theme.dart';
import 'fx/cursor_fx.dart';
import 'fx/reveal.dart';

/// White section — numbered service rows that invert to black on hover.
class ServicesSection extends StatelessWidget {
  final VoidCallback onStartProject;
  const ServicesSection({super.key, required this.onStartProject});

  static const _services = [
    ('Web Design & Development',
        'Fast, conversion-focused websites and web apps built with modern frameworks. Pixel-perfect UI, responsive across all devices.'),
    ('Mobile App Development',
        'Cross-platform iOS & Android apps that feel native. Built with Flutter for speed, performance, and beautiful UX.'),
    ('AI Agent Development',
        'Custom AI-powered workflows, chatbots, and automation agents that save your team hours every week.'),
    ('Branding & Identity',
        'Logos, color systems, typography, and brand guidelines that make you look established from day one.'),
  ];

  @override
  Widget build(BuildContext context) {
    return FxSection(
      dark: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Reveal(
            child: SectionHeader(
              label: 'Services',
              title: 'What I build',
              pro: true,
              aside: 'Every service is designed to deliver measurable results — '
                  'from first sketch to launch.',
              dark: false,
            ),
          ),
          const SizedBox(height: 64),
          Container(height: 1, color: Fx.fg(false, 0.15)),
          for (var i = 0; i < _services.length; i++)
            Reveal(
              delay: Duration(milliseconds: i * 80),
              dy: 30,
              child: _ServiceRow(
                title: _services[i].$1,
                desc: _services[i].$2,
                onTap: onStartProject,
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatefulWidget {
  final String title;
  final String desc;
  final VoidCallback onTap;
  const _ServiceRow({required this.title, required this.desc, required this.onTap});

  @override
  State<_ServiceRow> createState() => _ServiceRowState();
}

class _ServiceRowState extends State<_ServiceRow> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final wide = w > 900;

    return CursorHover(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _h = v),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: _h ? 1 : 0),
        duration: const Duration(milliseconds: 500),
        curve: Fx.ease,
        builder: (_, t, __) {
          final bg = Color.lerp(Fx.paper, Fx.ink, t)!;
          final fg = Color.lerp(Fx.ink, Colors.white, t)!;
          final muted = fg.withValues(alpha: 0.55);
          final title = Text(widget.title, style: Fx.pro(wide ? 32 : 24, color: fg));
          final desc = Text(widget.desc,
              style: Fx.pro(15, color: muted, weight: FontWeight.w400).copyWith(height: 1.65, letterSpacing: 0));
          final arrow = Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(Colors.transparent, Colors.white, t),
              border: Border.all(color: fg.withValues(alpha: 0.3 + 0.7 * t)),
            ),
            child: Transform.rotate(
              angle: -0.785 * (1 - t),
              child: Icon(Icons.arrow_forward_rounded,
                  size: 20, color: Color.lerp(Fx.ink, Fx.ink, t)),
            ),
          );

          return Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16 * t),
              border: Border(bottom: BorderSide(color: Fx.fg(false, 0.15 * (1 - t)))),
            ),
            padding: EdgeInsets.symmetric(horizontal: 28 * t, vertical: wide ? 40 : 28),
            child: wide
                ? Row(
                    children: [
                      Expanded(flex: 5, child: title),
                      const SizedBox(width: 40),
                      Expanded(flex: 4, child: desc),
                      const SizedBox(width: 48),
                      arrow,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      const SizedBox(height: 12),
                      desc,
                    ],
                  ),
          );
        },
      ),
    );
  }
}
