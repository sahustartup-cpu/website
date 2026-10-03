import 'package:flutter/material.dart';
import 'fx/fx_theme.dart';
import 'fx/cursor_fx.dart';
import 'fx/reveal.dart';

/// Black section — centred "—— Reviews" heading (About Me style) and compact white review cards
/// with yellow stars (4 per row on desktop, 2 on tablet, 1 on mobile).
/// The first row is shown; "View all reviews" expands to show the rest.
class ReviewsSection extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;
  const ReviewsSection({super.key, required this.reviews});

  static const star = Color(0xFFFFC107);

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  bool _showAll = false;

  Widget _row(List<Map<String, dynamic>> items, int cols) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var c = 0; c < cols; c++) ...[
                if (c > 0) const SizedBox(width: 16),
                Expanded(
                  child: c < items.length
                      ? Reveal(
                          delay: Duration(milliseconds: c * 100),
                          dy: 30,
                          child: _ReviewCard(r: items[c]),
                        )
                      : const SizedBox(),
                ),
              ],
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w > 1100 ? 4 : (w > 680 ? 2 : 1);
    final items = widget.reviews.where((r) => r['is_visible'] != false).toList();

    final rows = <List<Map<String, dynamic>>>[
      for (var i = 0; i < items.length; i += cols)
        items.sublist(i, (i + cols).clamp(0, items.length)),
    ];
    final first = rows.isEmpty ? <Map<String, dynamic>>[] : rows.first;
    final rest = rows.length > 1 ? rows.sublist(1) : <List<Map<String, dynamic>>>[];

    return FxSection(
      dark: true,
      top: 110,
      bottom: 110,
      child: Column(
        children: [
          // Same heading style as the About section's "About Me" label.
          const Reveal(child: AccentLabel('Reviews')),
          const SizedBox(height: 14),
          Reveal(
            delay: const Duration(milliseconds: 80),
            child: Text('What clients say about working with me.',
                textAlign: TextAlign.center,
                style: Fx.body(size: 17, color: Colors.white.withValues(alpha: 0.6))),
          ),
          const SizedBox(height: 48),
          if (items.isEmpty)
            Text('No reviews yet.', style: Fx.body(color: Fx.fg(true, 0.5)))
          else ...[
            _row(first, cols),
            AnimatedSize(
              duration: const Duration(milliseconds: 600),
              curve: Fx.ease,
              alignment: Alignment.topCenter,
              child: _showAll
                  ? Column(children: [for (final r in rest) _row(r, cols)])
                  : const SizedBox(width: double.infinity),
            ),
            if (rest.isNotEmpty) ...[
              const SizedBox(height: 16),
              _ViewAllButton(
                text: _showAll ? 'Show less' : 'View all reviews (${items.length})',
                expanded: _showAll,
                onTap: () => setState(() => _showAll = !_showAll),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _ViewAllButton extends StatefulWidget {
  final String text;
  final bool expanded;
  final VoidCallback onTap;
  const _ViewAllButton({required this.text, required this.expanded, required this.onTap});

  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return CursorHover(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _h = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: _h ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white.withValues(alpha: _h ? 1 : 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.text,
                style: Fx.body(size: 15, color: _h ? Fx.ink : Colors.white, height: 1.2)
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: widget.expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 400),
              curve: Fx.ease,
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: _h ? Fx.ink : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatefulWidget {
  final Map<String, dynamic> r;
  const _ReviewCard({required this.r});

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _h = false;

  String _initials(String name) {
    final p = name
        .replaceFirst(RegExp(r'^(mr|mrs|ms|dr)\.?\s+', caseSensitive: false), '')
        .trim()
        .split(RegExp(r'\s+'));
    if (p.isEmpty || p.first.isEmpty) return '?';
    return p.length >= 2 ? '${p[0][0]}${p[1][0]}'.toUpperCase() : p[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final name = (r['reviewer_name'] ?? '').toString();
    final stars = (r['stars'] ?? 5) as int;
    final subtitle = [r['role'], r['company']]
        .map((s) => (s ?? '').toString().trim())
        .where((s) => s.isNotEmpty)
        .join(', ');

    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Fx.ease,
        transform: Matrix4.translationValues(0, _h ? -5 : 0, 0),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: _h
              ? [BoxShadow(color: Colors.white.withValues(alpha: 0.12), blurRadius: 30, offset: const Offset(0, 10))]
              : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (i) => Icon(Icons.star_rounded,
                    size: 17,
                    color: i < stars ? ReviewsSection.star : Colors.black.withValues(alpha: 0.12)),
              ),
            ),
            const SizedBox(height: 14),
            Text(r['review_text']?.toString() ?? '',
                style: Fx.body(size: 14.5, color: Fx.ink, height: 1.6)),
            const SizedBox(height: 18),
            const Spacer(),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Fx.ink),
                  child: Text(_initials(name),
                      style: Fx.body(size: 11, color: Colors.white, height: 1)
                          .copyWith(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Fx.body(size: 14, color: Fx.ink, height: 1.3)
                              .copyWith(fontWeight: FontWeight.w600)),
                      if (subtitle.isNotEmpty)
                        Text(subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Fx.body(size: 12, color: Fx.ink.withValues(alpha: 0.5), height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
