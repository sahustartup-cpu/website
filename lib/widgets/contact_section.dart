import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';
import '../screens/privacy_policy_screen.dart';
import '../services/supabase_service.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      _snack('Please fill in your name and email.', error: true);
      return;
    }
    setState(() => _sending = true);
    final ok = await SupabaseService.sendContact(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _messageCtrl.text.trim(),
    );
    setState(() => _sending = false);
    if (ok) {
      _snack('Message sent! We will get back to you soon.');
      _nameCtrl.clear(); _emailCtrl.clear(); _messageCtrl.clear();
    } else {
      _snack('Something went wrong. Try again.', error: true);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      backgroundColor: error ? Colors.red[700] : AppColors.darkCard,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      margin: const EdgeInsets.all(20),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 800;
    final pad = isWide ? 60.0 : 24.0;

    return Container(
      color: AppColors.black,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 80),
      child: isWide ? _wideLayout() : _narrowLayout(),
    );
  }

  Widget _wideLayout() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: _leftContent()),
      const SizedBox(width: 80),
      Expanded(child: _formCard()),
    ],
  );

  Widget _narrowLayout() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_leftContent(), const SizedBox(height: 40), _formCard()],
  );

  Widget _leftContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Let's\ntalk",
          style: GoogleFonts.syne(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
            fontSize: 80,
            letterSpacing: -4,
            height: 0.85,
          )).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
      const SizedBox(height: 24),
      RichText(
        text: TextSpan(
          style: GoogleFonts.dmSans(fontSize: 17, height: 1.6),
          children: [
            const TextSpan(
              text: 'Have an idea in mind',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: ' — website, app, or rebrand? Let\'s make it real.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
    ],
  );

  Widget _formCard() => Container(
    padding: const EdgeInsets.all(40),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700),
            children: [
              const TextSpan(text: 'Have a project ', style: TextStyle(color: AppColors.black)),
              TextSpan(text: 'in mind?', style: TextStyle(color: AppColors.gray)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _field(_nameCtrl,    'Your Name',       'How should we call you?*'),
        const SizedBox(height: 14),
        _field(_emailCtrl,   'your@email.com',  'E-mail*', type: TextInputType.emailAddress),
        const SizedBox(height: 14),
        _field(_messageCtrl, 'Your message',    'Message*', lines: 4),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _sending ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: _sending
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text('Send Message', style: GoogleFonts.syne(fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                'By submitting, you agree to our Privacy Policy.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.gray,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.gray,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.1, end: 0);

  Widget _field(TextEditingController ctrl, String hint, String label,
      {int lines = 1, TextInputType? type}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 12, color: AppColors.gray, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      TextField(
        controller: ctrl,
        maxLines: lines,
        keyboardType: type,
        style: const TextStyle(color: Colors.black, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.3)),
          filled: true,
          fillColor: AppColors.lightBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _messageCtrl.dispose();
    super.dispose();
  }
}