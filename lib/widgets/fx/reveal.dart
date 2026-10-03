import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'fx_theme.dart';

/// Plays a one-shot animation the first time the child scrolls into view.
/// Default: fade + slide up. [mask]: the child slides up from behind a clip
/// (used for big headings, one line at a time).
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double dy;
  final bool mask;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 1000),
    this.dy = 48,
    this.mask = false,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _t = CurvedAnimation(parent: _c, curve: Fx.ease);
  final _key = UniqueKey();
  bool _fired = false;
  Timer? _timer;

  void _onVisible(VisibilityInfo info) {
    if (_fired || info.visibleFraction < 0.08) return;
    _fired = true;
    _timer = Timer(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: _onVisible,
      child: AnimatedBuilder(
        animation: _t,
        child: widget.child,
        builder: (_, child) {
          final t = _t.value;
          if (widget.mask) {
            return ClipRect(
              child: FractionalTranslation(
                translation: Offset(0, 1.05 * (1 - t)),
                child: child,
              ),
            );
          }
          return Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, (1 - t) * widget.dy),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// Number that counts up from 0 once it scrolls into view.
class CountUp extends StatefulWidget {
  final int value;
  final String suffix;
  final TextStyle style;
  const CountUp({super.key, required this.value, this.suffix = '', required this.style});

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1800));
  late final Animation<double> _t = CurvedAnimation(parent: _c, curve: Fx.ease);
  final _key = UniqueKey();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (i) {
        if (i.visibleFraction > 0.5 && !_c.isAnimating && _c.value == 0) _c.forward();
      },
      child: AnimatedBuilder(
        animation: _t,
        builder: (_, __) => Text(
          '${(widget.value * _t.value).round()}${widget.suffix}',
          style: widget.style,
        ),
      ),
    );
  }
}
