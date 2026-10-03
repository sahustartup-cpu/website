import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'fx_theme.dart';

/// Global pointer state shared by the cursor ring and the hero spotlight.
class CursorFx {
  static final ValueNotifier<Offset?> position = ValueNotifier(null);
  static final ValueNotifier<bool> hovering = ValueNotifier(false);
}

/// Tracks the mouse over the page and paints a trailing white dot with a dark
/// outline (readable on black, white and orange sections). Grows over
/// buttons and other interactive elements.
class CursorOverlay extends StatefulWidget {
  final Widget child;
  const CursorOverlay({super.key, required this.child});

  @override
  State<CursorOverlay> createState() => _CursorOverlayState();
}

class _CursorOverlayState extends State<CursorOverlay>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _ring = _RingState();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => _ring.step(
          CursorFx.position.value,
          CursorFx.hovering.value,
        ))
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _ring.dispose();
    super.dispose();
  }

  void _track(PointerEvent e) {
    if (e.kind == PointerDeviceKind.mouse) CursorFx.position.value = e.position;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _track,
      child: MouseRegion(
        opaque: false,
        onHover: _track,
        onExit: (_) => CursorFx.position.value = null,
        child: Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _RingPainter(_ring)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingState extends ChangeNotifier {
  Offset? ring;
  Offset? dot;
  double scale = 1;
  double visible = 0;

  void step(Offset? target, bool hover) {
    if (target == null) {
      if (visible > 0) {
        visible = math.max(0, visible - 0.08);
        notifyListeners();
      }
      return;
    }
    ring ??= target;
    final next = Offset.lerp(ring, target, 0.2)!;
    final ns = scale + ((hover ? 2.4 : 1.0) - scale) * 0.16;
    final nv = math.min(1.0, visible + 0.1);
    final changed = (next - ring!).distance > 0.05 ||
        (ns - scale).abs() > 0.001 ||
        nv != visible ||
        dot != target;
    ring = next;
    dot = target;
    scale = ns;
    visible = nv;
    if (changed) notifyListeners();
  }
}

class _RingPainter extends CustomPainter {
  final _RingState s;
  _RingPainter(this.s) : super(repaint: s);

  @override
  void paint(Canvas canvas, Size size) {
    final c = s.ring;
    if (c == null || s.visible <= 0) return;
    final v = s.visible;

    // White disc with a dark outline — readable on black, white and orange.
    final r = 7 * s.scale;
    final hoverT = ((s.scale - 1) / 1.4).clamp(0.0, 1.0);
    canvas.drawCircle(
      c,
      r,
      Paint()..color = Colors.white.withValues(alpha: v * (1 - 0.75 * hoverT)),
    );
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Fx.ink.withValues(alpha: 0.55 * v),
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => false;
}

/// Marks a widget as interactive for the cursor (click cursor, tap handler,
/// ring grows).
class CursorHover extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onHover;

  const CursorHover({
    super.key,
    required this.child,
    this.onTap,
    this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        CursorFx.hovering.value = true;
        onHover?.call(true);
      },
      onExit: (_) {
        CursorFx.hovering.value = false;
        onHover?.call(false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: child,
      ),
    );
  }
}

/// Pulls its child slightly toward the pointer while hovered.
class Magnetic extends StatefulWidget {
  final Widget child;
  final double strength;
  const Magnetic({super.key, required this.child, this.strength = 0.2});

  @override
  State<Magnetic> createState() => _MagneticState();
}

class _MagneticState extends State<Magnetic> {
  Offset _o = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        setState(() =>
            _o = (e.localPosition - box.size.center(Offset.zero)) * widget.strength);
      },
      onExit: (_) => setState(() => _o = Offset.zero),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Fx.ease,
        transform: Matrix4.translationValues(_o.dx, _o.dy, 0),
        child: widget.child,
      ),
    );
  }
}

/// Pill button. [primary] = solid fill; [dark] = placed on a black section.
/// On hover the fill wipes in from the bottom.
class FxButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool primary;
  final bool dark;

  const FxButton({
    super.key,
    required this.text,
    required this.onTap,
    this.primary = true,
    this.dark = true,
  });

  @override
  State<FxButton> createState() => _FxButtonState();
}

class _FxButtonState extends State<FxButton> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final fgColor = Fx.fg(widget.dark);      // white on dark
    final bgColor = Fx.fg(!widget.dark);     // black on dark
    // Primary: filled with the foreground colour; hover inverts to outline.
    final filled = widget.primary ? !_h : _h;
    final textColor = filled ? bgColor : fgColor;

    return Magnetic(
      child: CursorHover(
        onTap: widget.onTap,
        onHover: (v) => setState(() => _h = v),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Fx.ease,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
          decoration: BoxDecoration(
            color: filled ? fgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Fx.fg(widget.dark, filled ? 1 : 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 350),
                style: Fx.body(size: 15, color: textColor, height: 1.2)
                    .copyWith(fontWeight: FontWeight.w500),
                child: Text(widget.text),
              ),
              const SizedBox(width: 10),
              AnimatedRotation(
                turns: _h ? -0.125 : 0,
                duration: const Duration(milliseconds: 400),
                curve: Fx.ease,
                child: Icon(Icons.arrow_forward_rounded, size: 17, color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
