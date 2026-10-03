import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/privacy_policy_screen.dart';
import '../services/supabase_service.dart';
import 'fx/fx_theme.dart';
import 'fx/cursor_fx.dart';
import 'fx/reveal.dart';

/// Black footer: CTA, link columns, a full-width wordmark and the legal line.
class FooterWidget extends StatefulWidget {
  final List<(String, VoidCallback)> links;
  final VoidCallback onStartProject;
  final VoidCallback onTop;

  const FooterWidget({
    super.key,
    required this.links,
    required this.onStartProject,
    required this.onTop,
  });

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  List<Map<String, dynamic>> _socials = [];

  @override
  void initState() {
    super.initState();
    SupabaseService.fetchSocialLinks().then((d) {
      if (mounted) setState(() => _socials = d);
    });
  }

  Widget _column(String title, List<(String, VoidCallback)> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: Fx.label(Fx.fg(true, 0.4))),
          const SizedBox(height: 20),
          for (final it in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FooterLink(text: it.$1, onTap: it.$2),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final wide = w > 900;
    final pad = Fx.hPad(w);

    final cta = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(text: 'Have a project ', style: Fx.display(wide ? 52 : 36)),
          TextSpan(text: 'in mind?', style: Fx.serif(wide ? 52 : 36)),
        ])),
        const SizedBox(height: 28),
        FxButton(text: 'Start a project', onTap: widget.onStartProject),
      ],
    );

    final socials = [
      for (final s in _socials)
        (
          s['name'].toString(),
          () => launchUrl(Uri.parse(s['url'] as String), mode: LaunchMode.externalApplication),
        ),
    ];
    final columns = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _column('Navigate', widget.links),
        const SizedBox(width: 72),
        _column('Social', [
          ...socials,
          ('Email', () => launchUrl(Uri.parse('mailto:sahustartup@gmail.com'))),
        ]),
      ],
    );

    return Container(
      color: Fx.ink,
      padding: EdgeInsets.fromLTRB(pad, wide ? 120 : 80, pad, 32),
      child: FxContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 1, color: Fx.fg(true, 0.12)),
            SizedBox(height: wide ? 80 : 56),
            wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Expanded(child: cta), columns],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [cta, const SizedBox(height: 56), columns],
                  ),
            SizedBox(height: wide ? 96 : 64),
            Reveal(
              mask: true,
              duration: const Duration(milliseconds: 1400),
              child: SizedBox(
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text('SahuStartup', style: Fx.wordmark(200)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(height: 1, color: Fx.fg(true, 0.12)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 28,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('© ${DateTime.now().year} SahuStartup. All rights reserved.',
                    style: Fx.body(size: 13, color: Fx.fg(true, 0.4), height: 1)),
                _FooterLink(
                  text: 'Privacy Policy',
                  small: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                  ),
                ),
                _FooterLink(text: 'Back to top ↑', small: true, onTap: widget.onTop),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool small;
  const _FooterLink({required this.text, required this.onTap, this.small = false});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return CursorHover(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _h = v),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 250),
        style: Fx.body(
          size: widget.small ? 13 : 16,
          color: Fx.fg(true, _h ? 1 : (widget.small ? 0.4 : 0.7)),
          height: 1.2,
        ),
        child: Text(widget.text),
      ),
    );
  }
}
