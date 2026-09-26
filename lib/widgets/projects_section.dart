import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';

class ProjectsSection extends StatelessWidget {
  final List<Map<String, dynamic>> projects;

  const ProjectsSection({super.key, required this.projects});

  Color _hex(String? hex) {
    if (hex == null || !hex.startsWith('#') || hex.length < 7) return const Color(0xFF1A1A2E);
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  bool _lightBg(Color c) {
    final r = (c.r * 255.0).round();
    final g = (c.g * 255.0).round();
    final b = (c.b * 255.0).round();
    return (r * 0.299 + g * 0.587 + b * 0.114) > 186;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w > 800 ? 2 : 1;

    return Container(
      color: AppColors.lightBg,
      padding: EdgeInsets.symmetric(horizontal: w > 800 ? 60 : 24, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Featured Projects',
              style: GoogleFonts.syne(
                color: AppColors.black,
                fontWeight: FontWeight.w800,
                fontSize: w > 800 ? 64 : 36,
                letterSpacing: -2,
                height: 0.9,
              )).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 48),
          if (projects.isEmpty)
            Center(child: Text('No projects yet.', style: TextStyle(color: AppColors.gray)))
          else
            _buildGrid(cols),
        ],
      ),
    );
  }

  Widget _buildGrid(int cols) {
    final rows = <Widget>[];
    for (int i = 0; i < projects.length; i += cols) {
      final rowItems = projects.sublist(i, (i + cols).clamp(0, projects.length));
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: rowItems.asMap().entries.map((e) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: e.key == 0 ? 0 : 10,
                    right: e.key == rowItems.length - 1 ? 0 : 10,
                  ),
                  child: _ProjectCard(
                    project: e.value,
                    hexFn: _hex,
                    lightBgFn: _lightBg,
                    delay: (i + e.key) * 80,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final Color Function(String?) hexFn;
  final bool Function(Color) lightBgFn;
  final int delay;

  const _ProjectCard({
    required this.project,
    required this.hexFn,
    required this.lightBgFn,
    required this.delay,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final bg = widget.hexFn(p['bg_color'] as String?);
    final light = widget.lightBgFn(bg);
    final textColor = light ? Colors.black : Colors.white;
    final imageUrl = p['image_url'] as String?;
    final scale = _hovered ? 1.02 : 1.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
              child: Row(children: [
                Text(p['name'] ?? '',
                    style: GoogleFonts.syne(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    )),
                const SizedBox(width: 10),
                Text('/ ${p['year']}',
                    style: const TextStyle(color: AppColors.gray, fontSize: 14)),
              ]),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              transform: Matrix4.diagonal3Values(scale, scale, 1.0),
              transformAlignment: Alignment.center,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: bg),
                          errorWidget: (_, __, ___) => _fallback(p, bg, textColor),
                        )
                      : _fallback(p, bg, textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.delay)).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _fallback(Map p, Color bg, Color tc) => Container(
    color: bg,
    child: Center(
      child: Text((p['name'] ?? '').toString().toUpperCase(),
          style: GoogleFonts.syne(
            color: tc.withValues(alpha: 0.7),
            fontWeight: FontWeight.w800,
            fontSize: 28,
            letterSpacing: -1,
          )),
    ),
  );
}