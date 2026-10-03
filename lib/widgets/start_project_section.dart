import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/privacy_policy_screen.dart';
import '../services/supabase_service.dart';
import 'fx/fx_theme.dart';
import 'fx/cursor_fx.dart';
import 'fx/reveal.dart';

/// Orange call-to-action: headline + "Start a project" (opens the full
/// project brief overlay) on the left, a quick message form on the right.
class StartProjectSection extends StatefulWidget {
  final VoidCallback onStartProject;
  const StartProjectSection({super.key, required this.onStartProject});

  @override
  State<StartProjectSection> createState() => _StartProjectSectionState();
}

class _StartProjectSectionState extends State<StartProjectSection> {
  static const _email = 'sahustartup@gmail.com';
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      _snack('Please fill in your name and email.');
      return;
    }
    setState(() => _sending = true);
    final ok = await SupabaseService.sendContact(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _messageCtrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      _snack('Message sent! I will get back to you soon.');
      _nameCtrl.clear();
      _emailCtrl.clear();
      _messageCtrl.clear();
    } else {
      _snack('Something went wrong. Please try again.');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: Fx.body(size: 14, color: Colors.white, height: 1.3)),
      backgroundColor: Fx.ink,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      margin: const EdgeInsets.all(20),
    ));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final wide = w > 960;
    final pad = Fx.hPad(w);

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('START A PROJECT', style: Fx.label(Colors.white.withValues(alpha: 0.85))),
        const SizedBox(height: 22),
        Text("HAVE AN IDEA?\nLET'S BUILD IT TOGETHER.",
            style: Fx.condensed(Fx.clamp(w * 0.052, 40, 76), height: 1.05)),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            'Tell me about your website, app, AI agent or brand. Share a few '
            'details and I will reply with next steps, a timeline and a quote.',
            style: Fx.body(size: 17, color: Colors.white.withValues(alpha: 0.9), height: 1.65),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _SolidButton(
              text: 'Start a project',
              onTap: widget.onStartProject,
              bg: Fx.ink,
              fg: Colors.white,
            ),
            CursorHover(
              onTap: () => launchUrl(Uri.parse('mailto:$_email')),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(_email,
                    style: Fx.body(size: 16, color: Colors.white, height: 1.2).copyWith(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ],
    );

    final form = Container(
      padding: EdgeInsets.all(wide ? 36 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Send a quick message', style: Fx.pro(22, color: Fx.ink)),
          const SizedBox(height: 6),
          Text('Prefer a short note? Drop it here and I will get back to you.',
              style: Fx.body(size: 14, color: Fx.ink.withValues(alpha: 0.55), height: 1.4)),
          const SizedBox(height: 24),
          _field(_nameCtrl, 'Your name'),
          const SizedBox(height: 14),
          _field(_emailCtrl, 'Email address', type: TextInputType.emailAddress),
          const SizedBox(height: 14),
          _field(_messageCtrl, 'Tell me about your project', lines: 4),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: _sending
                ? const Center(
                    child: SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Fx.ink)),
                  )
                : _SolidButton(
                    text: 'Send message',
                    onTap: _submit,
                    bg: Fx.ink,
                    fg: Colors.white,
                    expand: true,
                  ),
          ),
          const SizedBox(height: 14),
          Center(
            child: CursorHover(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              ),
              child: Text('By submitting, you agree to the Privacy Policy.',
                  style: Fx.body(size: 12, color: Fx.ink.withValues(alpha: 0.45), height: 1.4)
                      .copyWith(decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );

    return Container(
      color: Fx.orange,
      padding: EdgeInsets.fromLTRB(pad, wide ? 120 : 80, pad, wide ? 120 : 80),
      child: FxContainer(
        child: Reveal(
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: left),
                    const SizedBox(width: 72),
                    Expanded(flex: 5, child: form),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [left, const SizedBox(height: 48), form],
                ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, {int lines = 1, TextInputType? type}) {
    return TextField(
      controller: ctrl,
      maxLines: lines,
      keyboardType: type,
      cursorColor: Fx.ink,
      style: Fx.body(size: 15, color: Fx.ink, height: 1.4),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Fx.body(size: 15, color: Fx.ink.withValues(alpha: 0.4), height: 1.4),
        filled: true,
        fillColor: const Color(0xFFF3F3F1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Fx.ink, width: 1.5),
        ),
      ),
    );
  }
}

class _SolidButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color bg;
  final Color fg;
  final bool expand;
  const _SolidButton({
    required this.text,
    required this.onTap,
    required this.bg,
    required this.fg,
    this.expand = false,
  });

  @override
  State<_SolidButton> createState() => _SolidButtonState();
}

class _SolidButtonState extends State<_SolidButton> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return CursorHover(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _h = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        decoration: BoxDecoration(
          color: _h ? Color.lerp(widget.bg, Colors.white, 0.18) : widget.bg,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.text,
                style: Fx.body(size: 15, color: widget.fg, height: 1.2)
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 10),
            AnimatedSlide(
              offset: _h ? const Offset(0.25, 0) : Offset.zero,
              duration: const Duration(milliseconds: 300),
              child: Icon(Icons.arrow_forward_rounded, size: 17, color: widget.fg),
            ),
          ],
        ),
      ),
    );
  }
}
