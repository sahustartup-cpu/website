import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../services/supabase_service.dart';
import '../widgets/nav_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/marquee_strip.dart';
import '../widgets/about_section.dart';
import '../widgets/trust_bar.dart';
import '../widgets/services_section.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/reviews_section.dart';
import '../widgets/faq_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_widget.dart';
import '../widgets/start_project_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollCtrl  = ScrollController();
  final _projectsKey = GlobalKey();
  final _reviewsKey  = GlobalKey();
  final _contactKey  = GlobalKey();

  Map<String, dynamic>? _hero;
  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _reviews  = [];
  bool _loading = true;
  bool _showStartProject = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      SupabaseService.fetchHero(),
      SupabaseService.fetchProjects(),
      SupabaseService.fetchReviews(),
    ]);
    if (!mounted) return;
    setState(() {
      _hero     = results[0] as Map<String, dynamic>?;
      _projects = results[1] as List<Map<String, dynamic>>;
      _reviews  = results[2] as List<Map<String, dynamic>>;
      _loading  = false;
    });
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: _loading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SahuStartup',
                      style: GoogleFonts.syne(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      )),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.white, strokeWidth: 2),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollCtrl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Hero section
                      HeroSection(
                        hero: _hero,
                        onStartProject: () => setState(() => _showStartProject = true),
                      ),

                      // 2. Marquee strip
                      const MarqueeStrip(),

                      // 3. About
                      const AboutSection(),

                      // 4. Trust Bar
                      const TrustBar(),

                      // 5. Services
                      ServicesSection(
                        onStartProject: () => setState(() => _showStartProject = true),
                      ),

                      // 6. How it works
                      const HowItWorksSection(),

                      // 7. Projects
                      ProjectsSection(key: _projectsKey, projects: _projects),

                      // 8. Reviews
                      ReviewsSection(key: _reviewsKey, reviews: _reviews),

                      // 9. FAQ
                      const FaqSection(),

                      // 10. Contact
                      ContactSection(key: _contactKey),

                      // 11. Footer
                      const FooterWidget(),
                    ],
                  ),
                ),

                // Sticky nav
                NavBar(
                  onProjects:      () => _scrollTo(_projectsKey),
                  onReviews:       () => _scrollTo(_reviewsKey),
                  onContact:       () => _scrollTo(_contactKey),
                  onStartProject:  () => setState(() => _showStartProject = true),
                  scrollController: _scrollCtrl,
                ),

                // Start a Project overlay
                if (_showStartProject)
                  StartProjectOverlay(
                    onClose: () => setState(() => _showStartProject = false),
                  ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }
}