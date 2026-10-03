import 'package:flutter/material.dart';
import 'fx/fx_theme.dart';
import 'fx/cursor_fx.dart';

/// Fixed top bar: wordmark, section links, CTA, and a thin scroll-progress
/// line. Transparent over the hero, solid black once scrolled.
class NavBar extends StatefulWidget {
  final ScrollController scrollController;
  final List<(String, VoidCallback)> links;
  final VoidCallback onStartProject;
  final VoidCallback onLogo;

  const NavBar({
    super.key,
    required this.scrollController,
    required this.links,
    required this.onStartProject,
    required this.onLogo,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final s = widget.scrollController.offset > 40;
    if (s != _scrolled) setState(() => _scrolled = s);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final compact = w < 1000;
    final pad = Fx.hPad(w);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            curve: Fx.ease,
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: _scrolled ? 14 : 26),
            decoration: BoxDecoration(
              color: _scrolled ? Fx.ink.withValues(alpha: 0.94) : Colors.transparent,
              border: Border(
                bottom: BorderSide(color: Fx.fg(true, _scrolled ? 0.08 : 0)),
              ),
            ),
            child: FxContainer(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: (!_scrolled && !compact)
                    ? _splitRow()
                    : Row(
                        key: const ValueKey('bar'),
                        children: [
                          CursorHover(
                            onTap: widget.onLogo,
                            child: Text('SahuStartup', style: Fx.wordmark(compact ? 19 : 22)),
                          ),
                          Expanded(
                            child: compact
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (final l in widget.links) _NavLink(text: l.$1, onTap: l.$2),
                                    ],
                                  ),
                          ),
                          _Cta(onTap: widget.onStartProject),
                        ],
                      ),
              ),
            ),
          ),
          // Scroll progress
          AnimatedBuilder(
            animation: widget.scrollController,
            builder: (_, __) {
              final c = widget.scrollController;
              final ready = c.hasClients && c.position.hasContentDimensions;
              final max = ready ? c.position.maxScrollExtent : 0.0;
              final p = max <= 0 ? 0.0 : (c.offset / max).clamp(0.0, 1.0);
              return Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: p,
                  child: Container(height: 1.5, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Top-of-page layout (reference style): three small caps links on the
  /// left, three on the right.
  Widget _splitRow() {
    final l = widget.links;
    final left = <(String, VoidCallback)>[('Home', widget.onLogo), l[0], l[2]];
    final right = <(String, VoidCallback)>[l[1], l[3], l[4]];
    return Row(
      key: const ValueKey('split'),
      children: [
        for (final x in left) _NavLink(text: x.$1, onTap: x.$2, caps: true),
        const Spacer(),
        for (final x in right) _NavLink(text: x.$1, onTap: x.$2, caps: true),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool caps;
  const _NavLink({required this.text, required this.onTap, this.caps = false});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return CursorHover(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _h = v),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(widget.caps ? widget.text.toUpperCase() : widget.text,
                  maxLines: 1,
                  softWrap: false,
                  style: widget.caps
                      ? Fx.body(size: 11, color: Colors.white, height: 1.3)
                          .copyWith(letterSpacing: 1.6, fontWeight: FontWeight.w500)
                      : Fx.body(size: 15, color: Colors.white, height: 1.3)),
            ),
            // Underline draws in from the left on hover.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: _h ? 1 : 0),
                duration: const Duration(milliseconds: 450),
                curve: Fx.ease,
                builder: (_, t, child) => Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.diagonal3Values(t, 1, 1),
                  child: child,
                ),
                child: Container(height: 1, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cta extends StatefulWidget {
  final VoidCallback onTap;
  const _Cta({required this.onTap});

  @override
  State<_Cta> createState() => _CtaState();
}

class _CtaState extends State<_Cta> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return CursorHover(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _h = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: _h ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white),
        ),
        child: Text("Let's talk",
            style: Fx.body(size: 14, color: _h ? Colors.white : Fx.ink, height: 1.2)
                .copyWith(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
