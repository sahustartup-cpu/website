import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'fx/fx_theme.dart';
import 'fx/cursor_fx.dart';
import 'fx/reveal.dart';

/// Projects bundled with the site (newest work).
const _localProjects = <Map<String, dynamic>>[
  {'name': 'Ardex', 'category': 'Analytics App', 'asset': 'ardex.webp'},
  {'name': 'Xefag', 'category': 'E-commerce App', 'asset': 'xefag.webp'},
  {'name': 'Season Statistic', 'category': 'Gaming App', 'asset': 'season_statistic.webp'},
  {'name': 'My Notes', 'category': 'Productivity App', 'asset': 'my_notes.webp'},
  {'name': 'Salon Booking', 'category': 'Booking App', 'asset': 'salon_booking.webp'},
  {'name': 'Caffora', 'category': 'Brand Website', 'asset': 'caffora.webp'},
  {'name': 'Green Bites', 'category': 'Food Ordering App', 'asset': 'green_bites.webp'},
];

/// Black section holding one rounded white box: a bold heading on top and two
/// rows of 4:3 project cards (same shape as the shots, so nothing is cut
/// off) scrolling in opposite directions underneath.
/// A row pauses while the mouse is over it.
class ProjectsSection extends StatelessWidget {
  final List<Map<String, dynamic>> projects; // from Supabase
  const ProjectsSection({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final wide = w > 800;
    final pad = Fx.hPad(w);
    final inner = wide ? 40.0 : 20.0;

    final all = [
      ..._localProjects,
      ...projects.where((p) => p['is_visible'] != false),
    ];
    // Split across the two rows so each row shows different work.
    final rowA = [for (var i = 0; i < all.length; i += 2) all[i]];
    final rowB = [for (var i = 1; i < all.length; i += 2) all[i]];

    final title = Text('FEATURED PROJECTS',
        style: Fx.condensed(Fx.clamp(w * 0.048, 38, 68), color: Fx.ink, height: 1.0));
    final note = Text(
      'Apps, websites and brands designed and shipped for founders and businesses.',
      style: Fx.body(size: 15, color: Fx.ink.withValues(alpha: 0.6), height: 1.6),
    );
    final count = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Fx.orange,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text('${all.length} projects',
          style: Fx.body(size: 13, color: Colors.white, height: 1.2)
              .copyWith(fontWeight: FontWeight.w600)),
    );

    return Container(
      color: Fx.ink,
      padding: EdgeInsets.fromLTRB(pad, wide ? 80 : 56, pad, wide ? 80 : 56),
      child: FxContainer(
        child: Reveal(
          dy: 50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(inner, inner, inner, 28),
                    child: wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SectionLabel('Selected work', dark: false),
                                    const SizedBox(height: 14),
                                    title,
                                  ],
                                ),
                              ),
                              const SizedBox(width: 32),
                              SizedBox(
                                width: 320,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [count, const SizedBox(height: 12), note],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SectionLabel('Selected work', dark: false),
                              const SizedBox(height: 12),
                              title,
                              const SizedBox(height: 14),
                              count,
                              const SizedBox(height: 12),
                              note,
                            ],
                          ),
                  ),
                  if (all.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(inner),
                      child: Text('No projects yet.', style: Fx.body(color: Fx.fg(false, 0.5))),
                    )
                  else ...[
                    _FrameRow(items: rowA, reverse: false),
                    const SizedBox(height: 14),
                    _FrameRow(items: rowB.isEmpty ? rowA : rowB, reverse: true),
                    SizedBox(height: inner),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FrameRow extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final bool reverse;
  const _FrameRow({required this.items, required this.reverse});

  @override
  State<_FrameRow> createState() => _FrameRowState();
}

class _FrameRowState extends State<_FrameRow> with SingleTickerProviderStateMixin {
  static const double _gap = 14;
  static const double _speed = 40; // px per second
  late final AnimationController _c = AnimationController(vsync: this);
  double _copyWidth = 0;

  void _configure(double copyWidth) {
    if (copyWidth == _copyWidth) return;
    _copyWidth = copyWidth;
    _c.duration = Duration(milliseconds: (copyWidth / _speed * 1000).round());
    _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final imageH = w > 800 ? 270.0 : 190.0;
    final cardW = imageH * 4 / 3;
    final h = imageH + _Frame.captionH;

    // Repeat the projects until one copy is wider than the screen, then
    // render that copy twice so the loop is seamless.
    final copy = <Map<String, dynamic>>[];
    while (copy.length * (cardW + _gap) < w + cardW) {
      copy.addAll(widget.items);
    }
    final copyWidth = copy.length * (cardW + _gap);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _configure(copyWidth);
    });

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var k = 0; k < 2; k++)
          for (final p in copy)
            Padding(
              padding: const EdgeInsets.only(right: _gap),
              child: SizedBox(width: cardW, height: h, child: _Frame(project: p)),
            ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => _c.stop(),
      onExit: (_) {
        if (_c.duration != null) _c.repeat();
      },
      child: ClipRect(
        child: SizedBox(
          height: h,
          child: OverflowBox(
            minWidth: 0,
            maxWidth: double.infinity,
            alignment: Alignment.centerLeft,
            child: AnimatedBuilder(
              animation: _c,
              child: row,
              builder: (_, child) {
                final t = widget.reverse ? 1 - _c.value : _c.value;
                return Transform.translate(offset: Offset(-copyWidth * t, 0), child: child);
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// One project card: the full 4:3 shot on top, name + type underneath.
class _Frame extends StatefulWidget {
  static const double captionH = 64;
  final Map<String, dynamic> project;
  const _Frame({required this.project});

  @override
  State<_Frame> createState() => _FrameState();
}

class _FrameState extends State<_Frame> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final asset = p['asset'] as String?;
    final imageUrl = p['image_url'] as String?;
    final name = (p['name'] ?? '').toString();
    final subtitle = (p['category'] ?? p['year'] ?? '').toString();
    const shade = Color(0xFFEFEFEC);

    Widget fallback() => Container(
          color: shade,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Text(name, textAlign: TextAlign.center, style: Fx.display(22, color: Fx.ink)),
        );

    // BoxFit.contain: the whole shot is always visible.
    final Widget image = asset != null
        ? Image.asset('assets/images/projects/$asset', fit: BoxFit.contain)
        : imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (_, __) => Container(color: shade),
                errorWidget: (_, __, ___) => fallback(),
              )
            : fallback();

    return CursorHover(
      onHover: (v) => setState(() => _h = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F4),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Fx.ink.withValues(alpha: _h ? 0.5 : 0.08)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: shade),
                    AnimatedScale(
                      scale: _h ? 1.04 : 1.0,
                      duration: const Duration(milliseconds: 900),
                      curve: Fx.ease,
                      child: image,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: AnimatedScale(
                        scale: _h ? 1 : 0,
                        duration: const Duration(milliseconds: 350),
                        curve: Fx.ease,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_outward_rounded, size: 17, color: Fx.ink),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _Frame.captionH,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Fx.pro(16, color: Fx.ink).copyWith(height: 1.2)),
                            if (subtitle.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(subtitle,
                                  maxLines: 1,
                                  style: Fx.body(size: 12, color: Fx.ink.withValues(alpha: 0.55), height: 1.2)),
                            ],
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _h ? 0 : -0.125,
                        duration: const Duration(milliseconds: 400),
                        curve: Fx.ease,
                        child: Icon(Icons.arrow_forward_rounded,
                            size: 18, color: Fx.ink.withValues(alpha: _h ? 1 : 0.5)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
