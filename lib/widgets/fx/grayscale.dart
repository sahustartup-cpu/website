import 'package:flutter/material.dart';
import 'fx_theme.dart';

/// Shows [child] in black & white, easing to full colour when [color] is true.
class GrayToColor extends StatelessWidget {
  final bool color;
  final Widget child;
  const GrayToColor({super.key, required this.color, required this.child});

  static List<double> _matrix(double t) {
    // t = 0 → greyscale, t = 1 → identity.
    const r = 0.2126, g = 0.7152, b = 0.0722;
    double m(double gray, double id) => gray + (id - gray) * t;
    return [
      m(r, 1), m(g, 0), m(b, 0), 0, 0,
      m(r, 0), m(g, 1), m(b, 0), 0, 0,
      m(r, 0), m(g, 0), m(b, 1), 0, 0,
      0, 0, 0, 1, 0,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: color ? 1 : 0),
      duration: const Duration(milliseconds: 700),
      curve: Fx.ease,
      child: child,
      builder: (_, t, child) => ColorFiltered(
        colorFilter: ColorFilter.matrix(_matrix(t)),
        child: child,
      ),
    );
  }
}
