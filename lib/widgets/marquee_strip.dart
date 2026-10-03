import 'package:flutter/material.dart';
import 'fx/fx_theme.dart';

/// White band with two rows of small rounded word boxes scrolling in opposite
/// directions.
class MarqueeStrip extends StatelessWidget {
  const MarqueeStrip({super.key});

  static const _services = [
    'Brand Identity', 'Web Design', 'Mobile Apps', 'AI Agents',
    'UI/UX Design', '3D Visuals', 'Landing Pages', 'Web Apps',
  ];
  static const _skills = [
    'Flutter', 'Next.js', 'Supabase', 'Figma', 'Firebase',
    'OpenAI', 'Automation', 'E-commerce', 'SEO', 'Dashboards',
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: w > 800 ? 36 : 26),
      child: const Column(
        children: [
          _PillRow(words: _services, seconds: 40, reverse: false),
          SizedBox(height: 10),
          _PillRow(words: _skills, seconds: 46, reverse: true),
        ],
      ),
    );
  }
}

class _PillRow extends StatefulWidget {
  final List<String> words;
  final int seconds;
  final bool reverse;
  const _PillRow({required this.words, required this.seconds, required this.reverse});

  @override
  State<_PillRow> createState() => _PillRowState();
}

class _PillRowState extends State<_PillRow> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: Duration(seconds: widget.seconds))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fontSize = w > 800 ? 14.0 : 12.0;

    Widget pill(String text, int i) {
      // Every third box is filled black for rhythm.
      final filled = i % 3 == 1;
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: fontSize * 1.15, vertical: fontSize * 0.6),
          decoration: BoxDecoration(
            color: filled ? Fx.ink : const Color(0xFFF4F4F1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Fx.ink.withValues(alpha: filled ? 1 : 0.12)),
          ),
          child: Text(
            text,
            style: Fx.body(size: fontSize, color: filled ? Colors.white : Fx.ink, height: 1.2)
                .copyWith(fontWeight: FontWeight.w500, letterSpacing: -0.1),
          ),
        ),
      );
    }

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var copy = 0; copy < 2; copy++)
          for (var i = 0; i < widget.words.length; i++) pill(widget.words[i], i),
      ],
    );

    return ClipRect(
      child: SizedBox(
        height: fontSize * 1.2 + fontSize * 1.2 + 4,
        child: OverflowBox(
          minWidth: 0,
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: AnimatedBuilder(
            animation: _c,
            child: row,
            builder: (_, child) {
              // Row holds two copies; shifting by half its width loops seamlessly.
              final t = widget.reverse ? 1 - _c.value : _c.value;
              return FractionalTranslation(translation: Offset(-0.5 * t, 0), child: child);
            },
          ),
        ),
      ),
    );
  }
}
