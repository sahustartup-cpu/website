import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final pad = w > 800 ? 80.0 : 24.0;

    final faqs = [
      ('Do you work with US clients?', 'Yes! I have successfully partnered with startups and businesses in the US, handling timezone differences seamlessly with clear communication and regular updates.'),
      ('What is your tech stack?', 'I specialize in Flutter for Web & Mobile, building high-performance apps with Supabase or Firebase as the backend. I also craft AI agents using OpenAI and LangChain.'),
      ('How does the process work?', 'We start with a discovery call, define a clear roadmap, and move through iterative development sprints where you see progress every week.'),
      ('How do we communicate?', 'I use Slack, email, and Zoom for meetings. I ensure timezone overlap to guarantee we are always aligned.'),
    ];

    return Container(
      color: AppColors.lightBg,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FAQ',
              style: GoogleFonts.dmSans(
                color: AppColors.gray,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              )),
          const SizedBox(height: 16),
          Text('Questions? Answers.',
              style: GoogleFonts.syne(
                color: AppColors.black,
                fontWeight: FontWeight.w800,
                fontSize: w > 800 ? 52 : 36,
                letterSpacing: -1.5,
              )),
          const SizedBox(height: 60),
          Column(
              children: faqs.map((f) => _FaqItem(f)).toList()
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final (String, String) faq;
  const _FaqItem(this.faq);
  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Colors.black.withValues(alpha: 0.1)),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(vertical: 8),
            onExpansionChanged: (v) => setState(() => _expanded = v),
            title: Text(widget.faq.$1,
                style: GoogleFonts.syne(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                )),
            trailing: Icon(_expanded ? Icons.remove : Icons.add, color: AppColors.black),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 40, 24),
                child: Text(widget.faq.$2,
                    style: GoogleFonts.dmSans(
                      color: AppColors.gray,
                      fontSize: 15,
                      height: 1.7,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
