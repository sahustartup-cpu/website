import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 800;
    final pad = isWide ? 120.0 : 24.0;
    final maxW = 860.0;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: pad, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back,
                              color: Colors.white.withValues(alpha: 0.5), size: 18),
                          const SizedBox(width: 8),
                          Text('Back',
                              style: GoogleFonts.dmSans(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Header
                  Text('Privacy Policy',
                      style: GoogleFonts.syne(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: isWide ? 64 : 40,
                        letterSpacing: -2,
                        height: 0.9,
                      )),

                  const SizedBox(height: 16),

                  Text('Last updated: June 1, 2026',
                      style: GoogleFonts.dmSans(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14,
                      )),

                  const SizedBox(height: 48),
                  _divider(),
                  const SizedBox(height: 48),

                  // Intro
                  _body(
                    'Welcome to SahuStartup. This Privacy Policy explains how Manoj Sahu ("I", "me", or "SahuStartup") collects, uses, and protects your personal information when you visit this website or use any of my services including web development, AI agent development, mobile app development, 3D development, and branding.',
                  ),

                  const SizedBox(height: 12),

                  _body(
                    'By using this website or contacting me through any form, you agree to the terms described in this Privacy Policy. If you do not agree, please do not use this website.',
                  ),

                  const SizedBox(height: 40),
                  _heading('1. Who I Am'),
                  _body(
                    'Name: Manoj Sahu\nBusiness: SahuStartup\nEmail: sahustartup@gmail.com\nServices: Web Development, AI Agent Development, Mobile App Development, 3D Development, and Branding.',
                  ),

                  const SizedBox(height: 40),
                  _heading('2. Information I Collect'),
                  _body('I only collect information that you voluntarily provide through contact forms or project inquiry forms on this website. This may include:'),
                  const SizedBox(height: 12),
                  _bullet('Your full name'),
                  _bullet('Your email address'),
                  _bullet('Your project description or message'),
                  _bullet('The type of service you are interested in'),
                  const SizedBox(height: 12),
                  _body('I do not collect any sensitive personal data such as payment details, passwords, government IDs, or financial information through this website.'),

                  const SizedBox(height: 40),
                  _heading('3. How I Use Your Information'),
                  _body('The information you provide is used solely to:'),
                  const SizedBox(height: 12),
                  _bullet('Respond to your inquiries and project requests'),
                  _bullet('Communicate with you about your project'),
                  _bullet('Provide the services you have requested'),
                  _bullet('Improve the quality of services offered'),
                  const SizedBox(height: 12),
                  _body('I will never use your information for unsolicited marketing, spam, or any purpose unrelated to your project without your explicit consent.'),

                  const SizedBox(height: 40),
                  _heading('4. Client Data & Project Confidentiality'),
                  _body(
                    'I take client confidentiality extremely seriously. Your project details, business information, designs, source code, strategies, and any other data shared during our engagement are treated as strictly confidential.',
                  ),
                  const SizedBox(height: 12),
                  _body(
                    'I do NOT share, sell, rent, disclose, or distribute any client data or project information to any third party under any circumstances, without your prior written consent.',
                  ),
                  const SizedBox(height: 12),
                  _body(
                    'This includes but is not limited to: project requirements, business strategies, design files, source code, API keys, credentials, and any other information exchanged during a project.',
                  ),

                  const SizedBox(height: 40),
                  _heading('5. Data Storage'),
                  _body(
                    'Information submitted through contact forms on this website is stored securely using Supabase, a trusted cloud database platform. This data is only accessible to me (Manoj Sahu) and is used exclusively to respond to your inquiry.',
                  ),
                  const SizedBox(height: 12),
                  _body(
                    'I retain your contact information only as long as necessary to fulfill the purpose for which it was collected, or as required by law.',
                  ),

                  const SizedBox(height: 40),
                  _heading('6. Cookies'),
                  _body(
                    'This website does not use tracking cookies or any third-party analytics tools that collect your personal data. The website is built purely to showcase my work and allow you to get in touch.',
                  ),

                  const SizedBox(height: 40),
                  _heading('7. Third-Party Services'),
                  _body(
                    'This website uses Supabase for data storage. Supabase has its own privacy policy and security standards. I do not share your data with any other third-party services, advertisers, or data brokers.',
                  ),

                  const SizedBox(height: 40),
                  _heading('8. Your Rights'),
                  _body('You have the following rights regarding your personal data:'),
                  const SizedBox(height: 12),
                  _bullet('Right to access — you can request a copy of the data I hold about you'),
                  _bullet('Right to correction — you can ask me to correct any inaccurate data'),
                  _bullet('Right to deletion — you can request that I delete your data at any time'),
                  _bullet('Right to withdraw consent — you can withdraw your consent at any time'),
                  const SizedBox(height: 12),
                  _body('To exercise any of these rights, please contact me at sahustartup@gmail.com and I will respond within 7 business days.'),

                  const SizedBox(height: 40),
                  _heading('9. Data Security'),
                  _body(
                    'I take appropriate technical and organisational measures to protect your personal information against unauthorised access, loss, misuse, or disclosure. However, no method of transmission over the internet is 100% secure, and I cannot guarantee absolute security.',
                  ),

                  const SizedBox(height: 40),
                  _heading('10. Children\'s Privacy'),
                  _body(
                    'This website is not directed to children under the age of 13. I do not knowingly collect personal information from children. If you believe a child has submitted information through this website, please contact me immediately at sahustartup@gmail.com.',
                  ),

                  const SizedBox(height: 40),
                  _heading('11. Changes to This Policy'),
                  _body(
                    'I may update this Privacy Policy from time to time to reflect changes in my practices or legal requirements. The updated policy will always be available on this page with the revised date at the top. I encourage you to review this policy periodically.',
                  ),

                  const SizedBox(height: 40),
                  _heading('12. Contact'),
                  _body('If you have any questions, concerns, or requests regarding this Privacy Policy or how I handle your data, please contact me:'),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _contactRow(Icons.person_outline, 'Manoj Sahu'),
                        const SizedBox(height: 12),
                        _contactRow(Icons.email_outlined, 'sahustartup@gmail.com'),
                        const SizedBox(height: 12),
                        _contactRow(Icons.business_outlined, 'SahuStartup'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                  _divider(),
                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      '© 2026 SahuStartup. All rights reserved.',
                      style: GoogleFonts.dmSans(
                        color: Colors.white.withValues(alpha: 0.25),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text,
          style: GoogleFonts.syne(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.5,
          )),
    );
  }

  Widget _body(String text) {
    return Text(text,
        style: GoogleFonts.dmSans(
          color: Colors.white.withValues(alpha: 0.65),
          fontSize: 15,
          height: 1.8,
        ));
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 5, height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: GoogleFonts.dmSans(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 15,
                  height: 1.8,
                )),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.white.withValues(alpha: 0.07),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.4), size: 18),
        const SizedBox(width: 12),
        Text(text,
            style: GoogleFonts.dmSans(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            )),
      ],
    );
  }
}
