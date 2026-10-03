import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'fx/fx_theme.dart';
import 'fx/cursor_fx.dart';

/// Orange editorial hero: headline top-left, client badge top-right, and a
/// giant SAHUSTARTUP wordmark that sits *behind* the cut-out portrait.
/// A warm light follows the cursor across the backdrop.
class HeroSection extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;
  final VoidCallback onStartProject;
  final VoidCallback onViewWork;

  const HeroSection({
    super.key,
    required this.reviews,
    required this.onStartProject,
    required this.onViewWork,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _light = _Light();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  void _tick(Duration elapsed) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;
    if (box.localToGlobal(Offset.zero).dy < -box.size.height) return;
    final g = CursorFx.position.value;
    Offset? local = g == null ? null : box.globalToLocal(g);
    if (local != null && !(Offset.zero & box.size).contains(local)) local = null;
    _light.step(box.size, local);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _light.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final wide = w > 900;
    final pad = Fx.hPad(w);
    final h = math.max(size.height, wide ? 720.0 : 700.0);
    // Wordmark spans the full width; Anton caps are ~0.47em wide.
    final markSize = (w - pad * 2) / 5.25;
    final personH = h * (wide ? 0.80 : 0.56);

    return SizedBox(
      height: h,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Backdrop + cursor light
          Positioned.fill(
            child: RepaintBoundary(child: CustomPaint(painter: _BackdropPainter(_light))),
          ),

          // Giant wordmark (behind the portrait)
          Positioned(
            left: pad,
            right: pad,
            bottom: -markSize * 0.16,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text('SAHUSTARTUP', style: Fx.condensed(200, height: 1)),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 900.ms)
                .slideY(begin: 0.35, end: 0, delay: 200.ms, duration: 1400.ms, curve: Fx.ease),
          ),

          // Cut-out portrait, centred and anchored to the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: personH,
            child: Image.asset(
              'assets/images/person_cutout.png',
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
              filterQuality: FilterQuality.medium,
            )
                .animate()
                .fadeIn(delay: 450.ms, duration: 900.ms)
                .slideY(begin: 0.12, end: 0, delay: 450.ms, duration: 1500.ms, curve: Fx.ease),
          ),

          // Top content
          Positioned(
            left: pad,
            right: pad,
            top: wide ? 104 : 92,
            child: FxContainer(
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Intro(w: w, onStartProject: widget.onStartProject),
                        const Spacer(),
                        _ClientBadge(reviews: widget.reviews, onViewWork: widget.onViewWork),
                      ],
                    )
                  : _Intro(w: w, onStartProject: widget.onStartProject),
            ),
          ),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  final double w;
  final VoidCallback onStartProject;
  const _Intro({required this.w, required this.onStartProject});

  @override
  Widget build(BuildContext context) {
    final wide = w > 900;
    return SizedBox(
      width: wide ? 400 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DESIGNING DIGITAL PRODUCTS FOR STARTUPS, BRANDS & GROWING BUSINESSES.',
            style: Fx.condensed(wide ? 30 : 26, height: 1.12),
          ).animate().fadeIn(delay: 300.ms, duration: 800.ms).slideY(begin: 0.3, end: 0, curve: Fx.ease),
          const SizedBox(height: 16),
          SizedBox(
            width: 340,
            child: Text(
              'SahuStartup designs and builds websites, mobile apps, AI agents '
              'and brand identities for founders in India and worldwide.',
              style: Fx.body(size: 13, color: Colors.white.withValues(alpha: 0.9), height: 1.6),
            ),
          ).animate().fadeIn(delay: 500.ms, duration: 800.ms),
          if (!wide) ...[
            const SizedBox(height: 20),
            _PillButton(text: 'Start a project', onTap: onStartProject)
                .animate()
                .fadeIn(delay: 650.ms, duration: 800.ms),
          ],
        ],
      ),
    );
  }
}

class _ClientBadge extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final VoidCallback onViewWork;
  const _ClientBadge({required this.reviews, required this.onViewWork});

  static String _initials(String name) {
    final p = name
        .replaceFirst(RegExp(r'^(mr|mrs|ms|dr)\.?\s+', caseSensitive: false), '')
        .trim()
        .split(RegExp(r'\s+'));
    if (p.isEmpty || p.first.isEmpty) return '?';
    return p.length >= 2 ? '${p[0][0]}${p[1][0]}'.toUpperCase() : p[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final shown = reviews.take(4).toList();
    const d = 38.0;
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shown.isNotEmpty)
            SizedBox(
              width: d + (shown.length - 1) * 24,
              height: d,
              child: Stack(
                children: [
                  for (var i = 0; i < shown.length; i++)
                    Positioned(
                      left: i * 24.0,
                      child: Container(
                        width: d,
                        height: d,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i.isEven ? Fx.charcoal : Colors.white,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          _initials((shown[i]['reviewer_name'] ?? '').toString()),
                          style: Fx.body(
                            size: 11,
                            color: i.isEven ? Colors.white : Fx.charcoal,
                            height: 1,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          Text(
            'TRUSTED BY FOUNDERS AND BUSINESSES ACROSS INDIA AND THE US FOR '
            'WEBSITES, APPS, AI AGENTS AND BRANDING.',
            style: Fx.body(size: 11, color: Colors.white, height: 1.7)
                .copyWith(letterSpacing: 2, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          _PillButton(text: 'View projects', onTap: onViewWork),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 900.ms).slideY(begin: 0.2, end: 0, curve: Fx.ease);
  }
}

/// Small white pill (reference "Explore Models" button).
class _PillButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _PillButton({required this.text, required this.onTap});

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return CursorHover(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _h = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: _h ? Fx.charcoal : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(widget.text,
            style: Fx.body(size: 12, color: _h ? Colors.white : Fx.charcoal, height: 1.2)
                .copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _Light extends ChangeNotifier {
  Offset? pos;
  double strength = 0;

  void step(Size s, Offset? cursor) {
    final target = cursor ?? Offset(s.width * 0.5, s.height * 0.45);
    pos = pos == null ? target : Offset.lerp(pos, target, 0.08);
    strength += ((cursor != null ? 1.0 : 0.0) - strength) * 0.06;
    notifyListeners();
  }
}

/// Warm studio backdrop (yellow core → deep orange edges) plus a soft light
/// that follows the cursor.
class _BackdropPainter extends CustomPainter {
  final _Light light;
  _BackdropPainter(this.light) : super(repaint: light);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, 0.05),
          radius: 0.95,
          colors: [Color(0xFFFDBE40), Color(0xFFF68A1A), Color(0xFFE0560B), Color(0xFF9A2A02)],
          stops: [0, 0.3, 0.6, 1],
        ).createShader(rect),
    );
    final p = light.pos;
    if (p == null || light.strength < 0.01) return;
    final r = size.shortestSide * 0.55;
    canvas.drawCircle(
      p,
      r,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFFFFE08A).withValues(alpha: 0.55 * light.strength),
          const Color(0xFFFFB347).withValues(alpha: 0.18 * light.strength),
          const Color(0xFFFFB347).withValues(alpha: 0),
        ], stops: const [0, 0.4, 1]).createShader(Rect.fromCircle(center: p, radius: r)),
    );
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter old) => false;
}
