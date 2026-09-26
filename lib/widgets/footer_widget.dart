import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../screens/privacy_policy_screen.dart';
import '../services/supabase_service.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  List<Map<String, dynamic>> _links = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await SupabaseService.fetchSocialLinks();
    if (mounted) setState(() => _links = data);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final pad = w > 800 ? 60.0 : 24.0;

    return Container(
      color: AppColors.black,
      padding: EdgeInsets.fromLTRB(pad, 20, pad, 40),
      child: Column(children: [
        const Divider(color: Color(0xFF222222)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Copyright
            Text('© 2026 SahuStartup. All rights reserved.',
                style: GoogleFonts.dmSans(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 13,
                )),

            // Links row
            Row(
              children: [
                // Privacy Policy
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen()),
                  ),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text('Privacy Policy',
                        style: GoogleFonts.dmSans(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white.withValues(alpha: 0.3),
                        )),
                  ),
                ),

                // Social links from Supabase
                ..._links.map((link) => Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: GestureDetector(
                    onTap: () => _launchUrl(link['url'] as String),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        link['name'] as String,
                        style: GoogleFonts.dmSans(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}