import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';

class ReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  const ReviewsSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;
    final pad = isWide ? 60.0 : 24.0;

    return Container(
      color: AppColors.lightBg,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Big title like original
          Text('Reviews',
              style: GoogleFonts.syne(
                color: AppColors.black,
                fontWeight: FontWeight.w800,
                fontSize: isWide ? 100 : 52,
                letterSpacing: -4,
                height: 0.88,
              )).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 12),

          Text("We can't wait to work with you!\nGet inspired by the success stories from our most recent projects.",
              style: GoogleFonts.dmSans(
                color: AppColors.gray,
                fontSize: 14,
                height: 1.6,
              )).animate().fadeIn(delay: 200.ms, duration: 600.ms),

          const SizedBox(height: 48),

          if (reviews.isEmpty)
            Center(child: Text('No reviews yet.', style: TextStyle(color: AppColors.gray)))
          else
            isWide ? _wideGrid() : _narrowList(),
        ],
      ),
    );
  }

  // Wide: featured card on left (larger), rest in 2-col grid on right
  Widget _wideGrid() {
    final featured = reviews.where((r) => r['is_featured'] == true).toList();
    final rest     = reviews.where((r) => r['is_featured'] != true).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured dark card — takes 40% width
        if (featured.isNotEmpty)
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _ReviewCard(r: featured.first, delay: 0),
            ),
          ),

        // Rest — 2 column grid, takes 60%
        Expanded(
          flex: 6,
          child: _twoColGrid(rest),
        ),
      ],
    );
  }

  Widget _twoColGrid(List<Map<String, dynamic>> items) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      final pair = items.sublist(i, (i + 2).clamp(0, items.length));
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: pair.asMap().entries.map((e) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: e.key == 0 ? 0 : 8, right: e.key == 0 ? 8 : 0),
                child: _ReviewCard(r: e.value, delay: (i + e.key) * 80),
              ),
            )).toList(),
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  // Narrow: all cards stacked
  Widget _narrowList() => Column(
    children: reviews.asMap().entries.map((e) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _ReviewCard(r: e.value, delay: e.key * 80),
    )).toList(),
  );
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> r;
  final int delay;
  const _ReviewCard({required this.r, required this.delay});

  Color _avatarColor(String name) {
    const colors = [
      Color(0xFFc0392b), Color(0xFF27ae60), Color(0xFF2980b9),
      Color(0xFF8e44ad), Color(0xFFe67e22), Color(0xFF16a085),
      Color(0xFFd35400),
    ];
    int h = 0;
    for (final c in name.codeUnits) h = c + ((h << 5) - h);
    return colors[h.abs() % colors.length];
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    return p.length >= 2
        ? '${p[0][0]}${p[1][0]}'.toUpperCase()
        : name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final featured = r['is_featured'] == true;
    final name     = (r['reviewer_name'] ?? '') as String;
    final stars    = (r['stars'] ?? 5) as int;
    final color    = _avatarColor(name);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        // Featured = dark black card (like original), normal = white card
        color: featured ? AppColors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: featured
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Orange stars — exactly like original
          Row(
            children: List.generate(5, (i) => Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(
                Icons.star_rounded,
                size: 18,
                color: i < stars
                    ? const Color(0xFFFF9800)   // orange like original
                    : Colors.grey.withValues(alpha: 0.25),
              ),
            )),
          ),

          const SizedBox(height: 16),

          // Review text
          Text('"${r['review_text'] ?? ''}"',
              style: GoogleFonts.dmSans(
                color: featured ? AppColors.white : AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.65,
              )),

          const SizedBox(height: 20),

          // Author row — avatar + name + role
          Row(
            children: [
              // Avatar circle like original
              r['avatar_url'] != null
                  ? CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(r['avatar_url'] as String),
                    )
                  : CircleAvatar(
                      radius: 22,
                      backgroundColor: color,
                      child: Text(
                        _initials(name),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(name,
                      style: GoogleFonts.dmSans(
                        color: featured ? AppColors.white : AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      )),
                  // Role · Company
                  Text(
                    '${r['role'] ?? ''}${r['company'] != null ? ' · ${r['company']}' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: featured
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppColors.gray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.08, end: 0);
  }
}
