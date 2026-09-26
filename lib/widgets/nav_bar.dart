import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class NavBar extends StatefulWidget {
  final VoidCallback onProjects;
  final VoidCallback onReviews;
  final VoidCallback onContact;
  final VoidCallback onStartProject;
  final ScrollController scrollController;

  const NavBar({
    super.key,
    required this.onProjects,
    required this.onReviews,
    required this.onContact,
    required this.onStartProject,
    required this.scrollController,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final screenH = MediaQuery.of(context).size.height;
    final isScrolled = widget.scrollController.offset > screenH * 0.85;
    if (isScrolled != _scrolled) {
      setState(() => _scrolled = isScrolled);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          // Transparent on hero, solid black after scrolling
          color: _scrolled
              ? AppColors.black.withValues(alpha: 0.95)
              : Colors.transparent,
          border: _scrolled
              ? Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)))
              : const Border(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        child: Row(
          children: [
            // Logo — left
            Text('SahuStartup',
                style: GoogleFonts.syne(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  letterSpacing: -1,
                )),

            // Nav links — CENTER
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _link('Projects', widget.onProjects),
                  _link('Reviews',  widget.onReviews),
                  _link('Contact',  widget.onContact),
                ],
              ),
            ),

            // CTA button — right
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: widget.onStartProject,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _scrolled ? AppColors.white : AppColors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: _scrolled
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  child: Text('Start a Project',
                      style: GoogleFonts.syne(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _link(String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Text(label,
              style: GoogleFonts.dmSans(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              )),
        ),
      ),
    );
  }
}