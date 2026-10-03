import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../widgets/fx/fx_theme.dart';
import '../widgets/fx/cursor_fx.dart';
import '../widgets/nav_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/marquee_strip.dart';
import '../widgets/about_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/services_section.dart';
import '../widgets/reviews_section.dart';
import '../widgets/faq_section.dart';
import '../widgets/start_project_section.dart';
import '../widgets/footer_widget.dart';
import '../widgets/start_project_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollCtrl  = ScrollController();
  final _aboutKey    = GlobalKey();
  final _projectsKey = GlobalKey();
  final _servicesKey = GlobalKey();
  final _reviewsKey  = GlobalKey();
  final _contactKey  = GlobalKey();

  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _reviews  = [];

  List<Map<String, dynamic>> _socials  = [];
  bool _showStartProject = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      SupabaseService.fetchProjects(),
      SupabaseService.fetchReviews(),
      SupabaseService.fetchSocialLinks(),
    ]);
    if (!mounted) return;
    setState(() {
      _projects = results[0];
      _reviews  = results[1]
          .where((r) => r['is_visible'] != false)
          .toList();
      _socials  = results[2];
    });
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(ctx,
        duration: const Duration(milliseconds: 1100), curve: Fx.ease);
  }

  void _toTop() => _scrollCtrl.animateTo(0,
      duration: const Duration(milliseconds: 1200), curve: Fx.ease);

  void _startProject() => setState(() => _showStartProject = true);

  @override
  Widget build(BuildContext context) {
    final links = <(String, VoidCallback)>[
      ('About',    () => _scrollTo(_aboutKey)),
      ('Work',     () => _scrollTo(_projectsKey)),
      ('Services', () => _scrollTo(_servicesKey)),
      ('Reviews',  () => _scrollTo(_reviewsKey)),
      ('Contact',  () => _scrollTo(_contactKey)),
    ];

    return Scaffold(
      backgroundColor: Fx.ink,
      body: CursorOverlay(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollCtrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Hero — orange editorial, wordmark behind the portrait
                  HeroSection(
                    reviews: _reviews,
                    onStartProject: _startProject,
                    onViewWork: () => _scrollTo(_projectsKey),
                  ),
                  // 2. About — square photo + bio
                  AboutSection(
                    key: _aboutKey,
                    socials: _socials,
                    onStartProject: _startProject,
                  ),
                  // 3. Two-row word strip (black)
                  const MarqueeStrip(),
                  // 4. Projects — wide cards, 2 per row (black)
                  ProjectsSection(key: _projectsKey, projects: _projects),
                  // 5. What I build (white)
                  ServicesSection(key: _servicesKey, onStartProject: _startProject),
                  // 6. Reviews — white cards, 3 per row (black)
                  ReviewsSection(key: _reviewsKey, reviews: _reviews),
                  // 7. Start a project (orange)
                  StartProjectSection(key: _contactKey, onStartProject: _startProject),
                  // 8. FAQ — centred (white)
                  const FaqSection(),
                  FooterWidget(
                    links: links,
                    onStartProject: _startProject,
                    onTop: _toTop,
                  ),
                ],
              ),
            ),
            NavBar(
              scrollController: _scrollCtrl,
              links: links,
              onStartProject: _startProject,
              onLogo: _toTop,
            ),
            if (_showStartProject)
              StartProjectOverlay(
                onClose: () => setState(() => _showStartProject = false),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }
}
