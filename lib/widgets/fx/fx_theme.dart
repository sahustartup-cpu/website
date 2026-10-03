import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Black & white design tokens.
class Fx {
  static const Color ink   = Color(0xFF0A0A0A); // black sections
  static const Color paper = Color(0xFFF4F4F1); // white sections
  static const Color white = Colors.white;

  // Hero + About (orange editorial look)
  static const Color orange   = Color(0xFFE5540F);
  static const Color charcoal = Color(0xFF141414);

  /// Tall condensed caps used by the hero and about headings.
  static TextStyle condensed(double size, {Color color = Colors.white, double height = 1.04}) =>
      GoogleFonts.anton(
        color: color,
        fontSize: size,
        height: height,
        letterSpacing: size * 0.005,
      );

  /// Clean, corporate sans for "professional" headings (Inter).
  static TextStyle pro(double size, {Color color = Colors.white, FontWeight weight = FontWeight.w600}) =>
      GoogleFonts.inter(
        color: color,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: -size * 0.03,
        height: 1.15,
      );

  /// Expo-out — the smooth ease used for every reveal.
  static const Curve ease = Cubic(0.16, 1, 0.3, 1);

  /// Foreground for a section: white on dark, ink on light, with [a] opacity.
  static Color fg(bool dark, [double a = 1]) =>
      (dark ? Colors.white : ink).withValues(alpha: a);

  /// Large headings — clean grotesk, tight tracking.
  static TextStyle display(double size, {Color color = Colors.white}) =>
      GoogleFonts.dmSans(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: size,
        letterSpacing: -size * 0.045,
        height: 1.0,
      );

  /// Italic serif used for accent words inside headings.
  static TextStyle serif(double size, {Color color = Colors.white}) =>
      GoogleFonts.instrumentSerif(
        color: color,
        fontStyle: FontStyle.italic,
        fontSize: size * 1.08,
        letterSpacing: -size * 0.01,
        height: 1.0,
      );

  static TextStyle body({double size = 16, required Color color, double height = 1.7}) =>
      GoogleFonts.dmSans(color: color, fontSize: size, height: height);

  /// Small uppercase eyebrow text.
  static TextStyle label(Color color) => GoogleFonts.dmSans(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.8,
      );

  /// Brand wordmark.
  static TextStyle wordmark(double size, {Color color = Colors.white}) =>
      GoogleFonts.syne(
        color: color,
        fontWeight: FontWeight.w800,
        fontSize: size,
        letterSpacing: -size * 0.05,
        height: 1.0,
      );

  static double clamp(double v, double lo, double hi) =>
      v < lo ? lo : (v > hi ? hi : v);

  static double hPad(double w) => w > 1200 ? 80 : (w > 800 ? 48 : 22);

  static const double maxWidth = 1280;
}

/// "—— ABOUT" eyebrow label.
class SectionLabel extends StatelessWidget {
  final String text;
  final bool dark;
  const SectionLabel(this.text, {super.key, this.dark = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 1,
          margin: const EdgeInsets.only(right: 12),
          color: Fx.fg(dark, 0.4),
        ),
        Text(text.toUpperCase(), style: Fx.label(Fx.fg(dark, 0.6))),
      ],
    );
  }
}

/// Orange bar + Inter label ("—— About Me"), used as a section heading.
class AccentLabel extends StatelessWidget {
  final String text;
  final Color color;
  const AccentLabel(this.text, {super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 900;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 3,
          decoration: BoxDecoration(color: Fx.orange, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 12),
        Text(text,
            style: Fx.pro(wide ? 18 : 16, color: color, weight: FontWeight.w600)
                .copyWith(letterSpacing: 0.2)),
      ],
    );
  }
}

/// Centers content and caps its width on very large screens.
class FxContainer extends StatelessWidget {
  final Widget child;
  const FxContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Fx.maxWidth),
          child: child,
        ),
      );
}

/// A full-width section band with consistent padding.
class FxSection extends StatelessWidget {
  final bool dark;
  final Widget child;
  final double top;
  final double bottom;

  const FxSection({
    super.key,
    required this.dark,
    required this.child,
    this.top = 130,
    this.bottom = 130,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final pad = Fx.hPad(w);
    final scale = w > 800 ? 1.0 : 0.65;
    return Container(
      color: dark ? Fx.ink : Fx.paper,
      padding: EdgeInsets.fromLTRB(pad, top * scale, pad, bottom * scale),
      child: FxContainer(child: child),
    );
  }
}

/// Section heading: label, big title (optionally with an italic serif
/// word) and a short note on the right.
class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String? serifWord; // appended in italic serif
  final String? aside;
  final bool dark;
  final bool pro; // title in the corporate sans (Inter) instead of grotesk + serif

  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.serifWord,
    this.aside,
    this.dark = true,
    this.pro = false,
  });

  @override
  Widget build(BuildContext context) {
    final h = this;
    final w = MediaQuery.of(context).size.width;
    final size = Fx.clamp(w * 0.058, 40, 84);
    final title = h.pro
        ? Text(h.title, style: Fx.pro(size, color: Fx.fg(h.dark), weight: FontWeight.w700))
        : Text.rich(TextSpan(children: [
            TextSpan(text: h.title, style: Fx.display(size, color: Fx.fg(h.dark))),
            if (h.serifWord != null)
              TextSpan(text: ' ${h.serifWord}', style: Fx.serif(size, color: Fx.fg(h.dark))),
          ]));
    final aside = h.aside == null
        ? null
        : Text(h.aside!, style: Fx.body(size: 16, color: Fx.fg(h.dark, 0.55)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(h.label, dark: h.dark),
        const SizedBox(height: 28),
        if (w > 900 && aside != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: title),
              const SizedBox(width: 40),
              SizedBox(width: 340, child: aside),
            ],
          )
        else ...[
          title,
          if (aside != null) ...[const SizedBox(height: 18), aside],
        ],
      ],
    );
  }
}
