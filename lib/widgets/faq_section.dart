import 'package:flutter/material.dart';
import 'fx/fx_theme.dart';
import 'fx/cursor_fx.dart';
import 'fx/reveal.dart';

/// White section — centred heading and a centred column of rounded
/// question boxes that expand to show the answer.
class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  static const _faqs = [
    ('Do you work with US clients?',
        'Yes! I have partnered with startups and businesses in the US, handling timezone differences with clear communication and regular updates.'),
    ('What is your tech stack?',
        'I specialize in Flutter for web & mobile, building high-performance apps with Supabase or Firebase as the backend. I also build AI agents using OpenAI and LangChain.'),
    ('How does the process work?',
        'We start with a discovery call, define a clear roadmap, and move through iterative development sprints where you see progress every week.'),
    ('How do we communicate?',
        'I use Slack, email, and Zoom for meetings, and make sure there is timezone overlap so we are always aligned.'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final pad = Fx.hPad(w);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(pad, w > 800 ? 120 : 80, pad, w > 800 ? 130 : 90),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            children: [
              Reveal(
                child: Text("FAQ'S",
                    textAlign: TextAlign.center,
                    style: Fx.pro(Fx.clamp(w * 0.06, 44, 80), color: Fx.ink, weight: FontWeight.w800)),
              ),
              const SizedBox(height: 16),
              Reveal(
                delay: const Duration(milliseconds: 140),
                child: Text('Everything you need to know before we start working together.',
                    textAlign: TextAlign.center,
                    style: Fx.body(size: 17, color: Fx.ink.withValues(alpha: 0.55))),
              ),
              const SizedBox(height: 56),
              for (var i = 0; i < _faqs.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Reveal(
                    delay: Duration(milliseconds: i * 80),
                    dy: 24,
                    child: _FaqItem(q: _faqs[i].$1, a: _faqs[i].$2, initiallyOpen: i == 0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String q;
  final String a;
  final bool initiallyOpen;
  const _FaqItem({required this.q, required this.a, this.initiallyOpen = false});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  late bool _open = widget.initiallyOpen;
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return CursorHover(
      onTap: () => setState(() => _open = !_open),
      onHover: (v) => setState(() => _h = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
        decoration: BoxDecoration(
          color: _open || _h ? const Color(0xFFF3F3F1) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Fx.ink.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(widget.q, style: Fx.pro(18, color: Fx.ink))),
                const SizedBox(width: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _open ? Fx.ink : Colors.transparent,
                    border: Border.all(color: Fx.ink.withValues(alpha: _open ? 1 : 0.2)),
                  ),
                  child: AnimatedRotation(
                    turns: _open ? 0.125 : 0,
                    duration: const Duration(milliseconds: 400),
                    curve: Fx.ease,
                    child: Icon(Icons.add_rounded, size: 18, color: _open ? Colors.white : Fx.ink),
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 450),
              curve: Fx.ease,
              alignment: Alignment.topLeft,
              child: _open
                  ? Padding(
                      padding: const EdgeInsets.only(top: 14, right: 50),
                      child: Text(widget.a,
                          style: Fx.body(size: 16, color: Fx.ink.withValues(alpha: 0.65))),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
