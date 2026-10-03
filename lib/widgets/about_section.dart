import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'fx/fx_theme.dart';
import 'fx/cursor_fx.dart';
import 'fx/reveal.dart';

/// Dark "about" block inside a rounded box: portrait photo on the left; on the right a big
/// two-line name (MANOJ / SAHU), role, description, button and socials.
/// On mobile the name sits above the photo.
class AboutSection extends StatelessWidget {
  final List<Map<String, dynamic>> socials;
  final VoidCallback onStartProject;

  const AboutSection({
    super.key,
    required this.socials,
    required this.onStartProject,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final wide = w > 900;
    final pad = Fx.hPad(w);
    final nameSize = wide ? Fx.clamp(w * 0.085, 88, 136) : Fx.clamp(w * 0.24, 64, 120);

    final labelRow = Row(
      children: [
        const Reveal(child: AccentLabel('About Me')),
        const Spacer(),
        _Starburst(size: wide ? 64 : 44),
      ],
    );

    final name = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(mask: true, child: Text('MANOJ', style: Fx.condensed(nameSize, height: 0.98))),
        Reveal(
          mask: true,
          delay: const Duration(milliseconds: 110),
          child: Text('SAHU', style: Fx.condensed(nameSize, color: Fx.orange, height: 0.98)),
        ),
      ],
    );

    const photo = _Photo();
    final info = _Info(socials: socials, onStartProject: onStartProject, wide: wide);

    final inner = wide ? 40.0 : 20.0;
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [labelRow, const SizedBox(height: 18), name, const SizedBox(height: 32), info],
    );
    // Desktop: the photo is exactly as tall as the text column, so its top
    // and bottom line up with the label and the buttons.
    final content = wide
        ? LayoutBuilder(builder: (context, c) {
            const gap = 56.0;
            final photoW = c.maxWidth * 0.42;
            return Stack(
              children: [
                Padding(padding: EdgeInsets.only(left: photoW + gap), child: textColumn),
                Positioned(left: 0, top: 0, bottom: 0, width: photoW, child: photo),
              ],
            );
          })
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelRow,
              const SizedBox(height: 16),
              name,
              const SizedBox(height: 32),
              const AspectRatio(aspectRatio: 3 / 4, child: photo),
              const SizedBox(height: 36),
              info,
            ],
          );

    // Same rounded box as the Featured Projects section.
    return Container(
      color: Fx.ink,
      padding: EdgeInsets.fromLTRB(pad, wide ? 80 : 56, pad, wide ? 80 : 56),
      child: FxContainer(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(31),
            child: Stack(
              children: [
                const Positioned.fill(child: CustomPaint(painter: _GridPainter())),
                Padding(padding: EdgeInsets.all(inner), child: content),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Portrait (3:4) photo, bundled as an optimised JPEG (the Supabase original
/// is a 1.6 MB PNG that can take tens of seconds to arrive).
class _Photo extends StatefulWidget {
  const _Photo();

  @override
  State<_Photo> createState() => _PhotoState();
}

class _PhotoState extends State<_Photo> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return Reveal(
      dy: 60,
      child: MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Fx.orange,
            child: AnimatedScale(
              scale: _h ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 1100),
              curve: Fx.ease,
              child: Image.asset(
                'assets/images/about_photo.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final List<Map<String, dynamic>> socials;
  final VoidCallback onStartProject;
  final bool wide;
  const _Info({required this.socials, required this.onStartProject, required this.wide});

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delay: const Duration(milliseconds: 180),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 14),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Fx.orange, width: 3)),
            ),
            child: Text('Designer & Developer · Founder, SahuStartup',
                style: Fx.body(size: wide ? 16 : 14, color: Colors.white, height: 1.4)
                    .copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.3)),
          ),
          const SizedBox(height: 26),
          Text(
            'I design and build digital products that turn visitors into loyal customers.',
            style: Fx.body(size: wide ? 24 : 20, color: Colors.white, height: 1.45)
                .copyWith(fontWeight: FontWeight.w500, letterSpacing: -0.3),
          ),
          const SizedBox(height: 18),
          Text(
            "I'm a full-stack designer and developer based in India. I help "
            'startups and growing businesses launch websites, mobile apps, AI '
            'agents and brand identities that look premium and convert — with '
            'the attention to detail big studios charge 5x more for.',
            style: Fx.body(size: wide ? 17 : 15, color: Colors.white.withValues(alpha: 0.68), height: 1.75),
          ),
          const SizedBox(height: 22),
          Text(
            '3+ years of experience · 20+ projects delivered · clients across India and the US',
            style: Fx.body(size: 14, color: Colors.white.withValues(alpha: 0.5), height: 1.6),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _OrangeButton(text: "Let's work together", onTap: onStartProject),
              const SizedBox(width: 8),
              for (final s in socials)
                _SocialDot(
                  icon: _iconFor(s['name'].toString()),
                  tooltip: s['name'].toString(),
                  onTap: () => launchUrl(Uri.parse(s['url'] as String),
                      mode: LaunchMode.externalApplication),
                ),
              _SocialDot(
                icon: Icons.mail_outline_rounded,
                tooltip: 'Email',
                onTap: () => launchUrl(Uri.parse('mailto:sahustartup@gmail.com')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static IconData _iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('insta')) return Icons.camera_alt_outlined;
    if (n.contains('linked')) return Icons.work_outline_rounded;
    if (n.contains('git')) return Icons.code_rounded;
    if (n.contains('twitter') || n == 'x') return Icons.alternate_email_rounded;
    if (n.contains('you')) return Icons.play_arrow_rounded;
    return Icons.link_rounded;
  }
}

class _OrangeButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _OrangeButton({required this.text, required this.onTap});

  @override
  State<_OrangeButton> createState() => _OrangeButtonState();
}

class _OrangeButtonState extends State<_OrangeButton> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return CursorHover(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _h = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: _h ? Colors.white : Fx.orange,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(widget.text,
            style: Fx.body(size: 13, color: _h ? Fx.charcoal : Colors.white, height: 1.2)
                .copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _SocialDot extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _SocialDot({required this.icon, required this.tooltip, required this.onTap});

  @override
  State<_SocialDot> createState() => _SocialDotState();
}

class _SocialDotState extends State<_SocialDot> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: CursorHover(
        onTap: widget.onTap,
        onHover: (v) => setState(() => _h = v),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _h ? Fx.orange : Colors.white,
          ),
          child: Icon(widget.icon, size: 17, color: _h ? Colors.white : Fx.charcoal),
        ),
      ),
    );
  }
}

/// Slowly spinning white starburst (reference sparkle icon).
class _Starburst extends StatefulWidget {
  final double size;
  const _Starburst({required this.size});

  @override
  State<_Starburst> createState() => _StarburstState();
}

class _StarburstState extends State<_Starburst> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 24))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _c,
      child: CustomPaint(size: Size.square(widget.size), painter: const _StarburstPainter()),
    );
  }
}

class _StarburstPainter extends CustomPainter {
  const _StarburstPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    const rays = 48;
    final p = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < rays; i++) {
      final a = i * 2 * math.pi / rays;
      final long = i.isEven;
      p.strokeWidth = long ? 1.6 : 1.1;
      final inner = r * 0.16;
      final outer = r * (long ? 1.0 : 0.66);
      canvas.drawLine(
        c + Offset(math.cos(a), math.sin(a)) * inner,
        c + Offset(math.cos(a), math.sin(a)) * outer,
        p,
      );
    }
    canvas.drawCircle(c, r * 0.2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Faint vertical guide lines across the section.
class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;
    const cols = 6;
    for (var i = 1; i < cols; i++) {
      final x = size.width * i / cols;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
