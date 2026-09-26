import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get _db => Supabase.instance.client;

  // ── HERO ──────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> fetchHero() async {
    try {
      final data = await _db.from('hero').select().limit(1).single();
      debugPrint('✅ Hero loaded: ${data['heading']}');
      return data;
    } catch (e) {
      debugPrint('❌ Hero error: $e');
      return null;
    }
  }

  // ── PROJECTS ──────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> fetchProjects() async {
    try {
      final data = await _db
          .from('projects')
          .select('id, name, year, image_url, bg_color, sort_order, is_visible')
          .order('sort_order', ascending: true);

      final list = List<Map<String, dynamic>>.from(data);
      debugPrint('✅ Projects loaded: ${list.length} total');
      for (final p in list) {
        debugPrint('   → ${p['name']} (${p['year']}) visible=${p['is_visible']}');
      }
      return list;
    } catch (e) {
      debugPrint('❌ Projects error: $e');
      return [];
    }
  }

  // ── REVIEWS ───────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> fetchReviews() async {
    try {
      final data = await _db
          .from('reviews')
          .select('id, reviewer_name, role, company, stars, review_text, avatar_url, is_featured, sort_order, is_visible')
          .order('is_featured', ascending: false)
          .order('sort_order', ascending: true);

      final list = List<Map<String, dynamic>>.from(data);
      debugPrint('✅ Reviews loaded: ${list.length} total');
      for (final r in list) {
        debugPrint('   → ${r['reviewer_name']} featured=${r['is_featured']}');
      }
      return list;
    } catch (e) {
      debugPrint('❌ Reviews error: $e');
      return [];
    }
  }

  // ── SUBMIT CONTACT ─────────────────────────────────────────
  static Future<bool> sendContact(String name, String email, String message) async {
    try {
      await _db.from('contact_messages').insert({
        'name': name,
        'email': email,
        'message': message,
      });
      debugPrint('✅ Contact submitted by $name');
      return true;
    } catch (e) {
      debugPrint('❌ Contact error: $e');
      return false;
    }
  }

  // ── SOCIAL LINKS ──────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> fetchSocialLinks() async {
    try {
      final data = await _db
          .from('social_links')
          .select('id, name, url, sort_order')
          .eq('is_visible', true)
          .order('sort_order', ascending: true);
      final list = List<Map<String, dynamic>>.from(data);
      debugPrint('✅ Social links loaded: ${list.length}');
      return list;
    } catch (e) {
      debugPrint('❌ Social links error: $e');
      return [];
    }
  }

  // ── SUBMIT PROJECT ─────────────────────────────────────────
  static Future<bool> sendProject(
      String name, String email, String message, List<String> services) async {
    try {
      await _db.from('project_submissions').insert({
        'name': name,
        'email': email,
        'message': message,
        'services': services,
      });
      debugPrint('✅ Project submitted by $name — services: $services');
      return true;
    } catch (e) {
      debugPrint('❌ Project error: $e');
      return false;
    }
  }
}