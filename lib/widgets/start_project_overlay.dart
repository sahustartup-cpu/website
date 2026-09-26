import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../screens/privacy_policy_screen.dart';
import '../services/supabase_service.dart';

class StartProjectOverlay extends StatefulWidget {
  final VoidCallback onClose;
  const StartProjectOverlay({super.key, required this.onClose});

  @override
  State<StartProjectOverlay> createState() => _StartProjectOverlayState();
}

class _StartProjectOverlayState extends State<StartProjectOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();
  final Set<String> _selected = {};
  bool _sending   = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  Future<void> _close() async {
    await _ctrl.reverse();
    widget.onClose();
  }

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      _showSnack('Please fill in your name and email.', error: true);
      return;
    }
    setState(() => _sending = true);
    final ok = await SupabaseService.sendProject(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _messageCtrl.text.trim(),
      _selected.toList(),
    );
    setState(() => _sending = false);
    if (ok) {
      setState(() => _submitted = true);
      await Future.delayed(const Duration(seconds: 2));
      _close();
    } else {
      _showSnack('Something went wrong. Please try again.', error: true);
    }
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      backgroundColor: error ? Colors.red[700] : AppColors.darkCard,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      margin: const EdgeInsets.all(20),
    ));
  }

  void _toggle(String name) {
    setState(() {
      if (_selected.contains(name)) {
        _selected.remove(name);
      } else {
        _selected.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 800;

    return FadeTransition(
      opacity: _fade,
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFF111111)),
        child: _submitted ? _successScreen() : Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 60 : 20,
                  vertical: 20,
                ),
                child: isWide ? _wideLayout() : _narrowLayout(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          Text('SahuStartup',
              style: GoogleFonts.syne(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              )),
          const Spacer(),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _close,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Icon(Icons.close,
                    color: Colors.white.withValues(alpha: 0.6), size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _successScreen() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 24),
        Text('Project Submitted!',
            style: GoogleFonts.syne(
              color: AppColors.white, fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text("We'll get back to you soon.",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16)),
      ]),
    );
  }

  // ── WIDE LAYOUT ───────────────────────────────────────────
  Widget _wideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT — fixed 340px, "Start a" + "Project" each on own line
        SizedBox(
          width: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Start a',
                  style: GoogleFonts.syne(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 52,
                    letterSpacing: -2,
                    height: 1.0,
                  )),
              Text('Project',
                  style: GoogleFonts.syne(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 52,
                    letterSpacing: -2,
                    height: 1.0,
                  )),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.dmSans(fontSize: 13, height: 1.6),
                  children: [
                    const TextSpan(
                        text: 'Have an idea in mind',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: " — website, app, or rebrand? Let's make it real.",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
                  ],
                ),
              ),
            ],
          ),
        ),

        // GAP
        const SizedBox(width: 80),

        // RIGHT — Expanded fills remaining space, no overflow
        Expanded(
          child: _formContent(),
        ),
      ],
    );
  }

  // ── NARROW LAYOUT ─────────────────────────────────────────
  Widget _narrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Start a Project',
            style: GoogleFonts.syne(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              fontSize: 32,
              letterSpacing: -1.5,
            )),
        const SizedBox(height: 8),
        Text("Have an idea in mind — let's make it real.",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
        const SizedBox(height: 28),
        _formContent(),
      ],
    );
  }

  // ── FORM CONTENT ──────────────────────────────────────────
  Widget _formContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label
        Text('What do you need?',
            style: GoogleFonts.dmSans(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 13,
            )),
        const SizedBox(height: 14),

        // 2x2 Service cards — fully responsive, fills available width
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.5,
          children: [
            _ServiceCard(
              name: 'Web Design',
              selected: _selected.contains('Web Design'),
              onTap: () => _toggle('Web Design'),
              svgPainter: const _WebDesignPainter(),
            ),
            _ServiceCard(
              name: 'Mobile App',
              selected: _selected.contains('Mobile App'),
              onTap: () => _toggle('Mobile App'),
              svgPainter: const _MobileAppPainter(),
            ),
            _ServiceCard(
              name: 'AI Agent',
              selected: _selected.contains('AI Agent'),
              onTap: () => _toggle('AI Agent'),
              svgPainter: const _AIAgentPainter(),
            ),
            _ServiceCard(
              name: 'Branding',
              selected: _selected.contains('Branding'),
              onTap: () => _toggle('Branding'),
              svgPainter: const _BrandingPainter(),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Tell us about you
        Text('Tell us about you',
            style: GoogleFonts.dmSans(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 13,
            )),
        const SizedBox(height: 14),

        // Name + Email row
        Row(
          children: [
            Expanded(child: _field(_nameCtrl, 'Your name', 'How should we call you?*')),
            const SizedBox(width: 14),
            Expanded(child: _field(_emailCtrl, 'your@email.com', 'E-mail*',
                type: TextInputType.emailAddress)),
          ],
        ),
        const SizedBox(height: 14),

        // Message
        _field(_messageCtrl, 'Your Message (optional)', 'Message', lines: 5),

        const SizedBox(height: 24),

        // Bottom — policy + send button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    'By submitting, you agree to our Privacy Policy.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.4),
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _sending ? null : _submit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: _sending
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text('Send Now',
                          style: GoogleFonts.syne(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          )),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _field(TextEditingController ctrl, String hint, String label,
      {int lines = 1, TextInputType? type}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.35),
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: lines,
          keyboardType: type,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.18)),
            filled: true,
            fillColor: const Color(0xFF1A1A1A),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.35), width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }
}

// ── SERVICE CARD ──────────────────────────────────────────────
class _ServiceCard extends StatefulWidget {
  final String name;
  final bool selected;
  final VoidCallback onTap;
  final CustomPainter svgPainter;

  const _ServiceCard({
    required this.name,
    required this.selected,
    required this.onTap,
    required this.svgPainter,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final sel = widget.selected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: sel
                ? const Color(0xFF1E1E1E)
                : _hovered
                    ? const Color(0xFF181818)
                    : const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: sel
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.08),
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Stack(
            children: [
              // Decorative × marks
              Positioned(
                top: 0, right: 16,
                child: Text('×',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.18),
                        fontSize: 13)),
              ),
              Positioned(
                top: 0, right: 40,
                child: Text('×',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.10),
                        fontSize: 11)),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Radio — top left
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sel ? Colors.white : Colors.transparent,
                      border: Border.all(
                        color: sel
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: sel
                        ? const Icon(Icons.circle, size: 10, color: Colors.black)
                        : null,
                  ),

                  const Spacer(),

                  // Line-art icon — centered
                  Center(
                    child: CustomPaint(
                      size: const Size(90, 60),
                      painter: widget.svgPainter,
                    ),
                  ),

                  const Spacer(),

                  // Label — bottom center
                  Center(
                    child: Text(
                      widget.name,
                      style: GoogleFonts.dmSans(
                        color: Colors.white.withValues(alpha: sel ? 0.9 : 0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── PAINTERS ─────────────────────────────────────────────────

class _WebDesignPainter extends CustomPainter {
  const _WebDesignPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final monW = size.width * 0.70;
    final monH = size.height * 0.68;
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, monW, monH), const Radius.circular(4)), p);
    canvas.drawRect(Rect.fromLTWH(6, 7, monW - 12, monH - 18), p);
    canvas.drawLine(Offset(monW * 0.5, monH), Offset(monW * 0.5, size.height * 0.88), p);
    canvas.drawLine(Offset(monW * 0.28, size.height * 0.88),
        Offset(monW * 0.72, size.height * 0.88), p);

    final fp = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRect(Rect.fromLTWH(10, 12, 14, 10), fp);
    final cursor = Path()
      ..moveTo(30, 18)
      ..lineTo(33, 26)
      ..lineTo(35, 23)
      ..lineTo(38, 28);
    canvas.drawPath(cursor, fp);

    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.62, 8, size.width * 0.36, monH - 6),
        const Radius.circular(4)),
        p..strokeWidth = 1.2..color = Colors.white.withValues(alpha: 0.4));
  }
  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class _MobileAppPainter extends CustomPainter {
  const _MobileAppPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.06, 2, size.width * 0.32, size.height * 0.90),
        const Radius.circular(6)), p);
    canvas.drawLine(Offset(size.width * 0.14, 8), Offset(size.width * 0.28, 8),
        p..strokeWidth = 1.2);
    canvas.drawLine(Offset(size.width * 0.15, size.height * 0.82),
        Offset(size.width * 0.29, size.height * 0.82), p);

    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.44, 2, size.width * 0.32, size.height * 0.90),
        const Radius.circular(6)), p..strokeWidth = 1.5);
    canvas.drawLine(Offset(size.width * 0.52, 8), Offset(size.width * 0.66, 8),
        p..strokeWidth = 1.2);
    canvas.drawLine(Offset(size.width * 0.52, size.height * 0.82),
        Offset(size.width * 0.66, size.height * 0.82), p);

    final ip = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final heart = Path()
      ..moveTo(size.width * 0.79, size.height * 0.25)
      ..cubicTo(size.width * 0.84, size.height * 0.18,
          size.width * 0.92, size.height * 0.24,
          size.width * 0.92, size.height * 0.33)
      ..cubicTo(size.width * 0.92, size.height * 0.46,
          size.width * 0.79, size.height * 0.56,
          size.width * 0.79, size.height * 0.56)
      ..cubicTo(size.width * 0.79, size.height * 0.56,
          size.width * 0.66, size.height * 0.46,
          size.width * 0.66, size.height * 0.33)
      ..cubicTo(size.width * 0.66, size.height * 0.24,
          size.width * 0.74, size.height * 0.18,
          size.width * 0.79, size.height * 0.25);
    canvas.drawPath(heart, ip);
    canvas.drawCircle(Offset(size.width * 0.79, size.height * 0.74), 8, ip);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.72, size.height * 0.78, 14, 10), ip);
  }
  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class _AIAgentPainter extends CustomPainter {
  const _AIAgentPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final cx = size.width * 0.38;
    final cy = size.height * 0.46;
    final r  = size.width * 0.20;

    canvas.drawArc(Rect.fromCircle(center: Offset(cx - r * 0.3, cy), radius: r * 0.72),
        0.6, 5.0, false, p);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx + r * 0.3, cy), radius: r * 0.72),
        3.8, 5.0, false, p);

    final dp = Paint()..color = Colors.white.withValues(alpha: 0.5)..style = PaintingStyle.fill;
    final dots = [
      Offset(cx, cy - 8), Offset(cx - 10, cy + 2),
      Offset(cx + 10, cy + 2), Offset(cx, cy + 12),
    ];
    for (final d in dots) canvas.drawCircle(d, 2.5, dp);

    final lp = Paint()..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke..strokeWidth = 1.0;
    canvas.drawLine(dots[0], dots[1], lp);
    canvas.drawLine(dots[0], dots[2], lp);
    canvas.drawLine(dots[1], dots[3], lp);
    canvas.drawLine(dots[2], dots[3], lp);

    void drawStar(Offset center, double r2) {
      final sp = Path()
        ..moveTo(center.dx, center.dy - r2 * 1.8)
        ..lineTo(center.dx + r2 * 0.4, center.dy - r2 * 0.4)
        ..lineTo(center.dx + r2 * 1.8, center.dy)
        ..lineTo(center.dx + r2 * 0.4, center.dy + r2 * 0.4)
        ..lineTo(center.dx, center.dy + r2 * 1.8)
        ..lineTo(center.dx - r2 * 0.4, center.dy + r2 * 0.4)
        ..lineTo(center.dx - r2 * 1.8, center.dy)
        ..lineTo(center.dx - r2 * 0.4, center.dy - r2 * 0.4)
        ..close();
      canvas.drawPath(sp, Paint()..color = Colors.white.withValues(alpha: 0.55)..style = PaintingStyle.fill);
    }

    drawStar(Offset(size.width * 0.80, size.height * 0.20), 5);
    drawStar(Offset(size.width * 0.92, size.height * 0.40), 3);
    drawStar(Offset(size.width * 0.70, size.height * 0.10), 3);

    canvas.drawLine(Offset(cx - 14, size.height * 0.80),
        Offset(cx + 14, size.height * 0.80), lp..strokeWidth = 1.2);
    canvas.drawLine(Offset(cx - 6, size.height * 0.80),
        Offset(cx - 6, size.height * 0.94), lp);
    canvas.drawLine(Offset(cx + 6, size.height * 0.80),
        Offset(cx + 6, size.height * 0.94), lp);
    canvas.drawCircle(Offset(cx - 6, size.height * 0.94), 2.5, dp);
    canvas.drawCircle(Offset(cx + 6, size.height * 0.94), 2.5, dp);
  }
  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class _BrandingPainter extends CustomPainter {
  const _BrandingPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final docW = size.width * 0.38;
    final docH = size.height * 0.82;
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.36, 2, docW, docH),
        const Radius.circular(4)), p);
    canvas.drawLine(Offset(size.width * 0.60, 2),
        Offset(size.width * 0.60, 12), p..strokeWidth = 1.2);
    canvas.drawLine(Offset(size.width * 0.60, 12),
        Offset(size.width * 0.74, 12), p);
    canvas.drawLine(Offset(size.width * 0.41, 20),
        Offset(size.width * 0.68, 20), p);
    canvas.drawLine(Offset(size.width * 0.41, 28),
        Offset(size.width * 0.60, 28), p);

    final sw = Paint()..style = PaintingStyle.fill;
    final swatches = [0.6, 0.35, 0.15];
    for (int i = 0; i < 3; i++) {
      sw.color = Colors.white.withValues(alpha: swatches[i]);
      canvas.drawRect(Rect.fromLTWH(
          size.width * 0.41 + i * 11, docH * 0.74, 9, 9), sw);
    }

    final pp = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    final palCx = size.width * 0.20;
    final palCy = size.height * 0.52;
    canvas.drawCircle(Offset(palCx, palCy), size.width * 0.17, pp);

    final dotP = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.5);
    for (final d in [
      Offset(palCx - 8, palCy - 4), Offset(palCx, palCy - 12),
      Offset(palCx + 8, palCy - 4), Offset(palCx + 8, palCy + 6),
    ]) {
      canvas.drawCircle(d, 3, dotP);
    }
    canvas.drawCircle(Offset(palCx - 4, palCy + 6), 4,
        pp..style = PaintingStyle.stroke);
  }
  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}