import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const SahuStartupApp());
}

class SahuStartupApp extends StatelessWidget {
  const SahuStartupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SahuStartup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.black,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.white,
          surface: AppColors.black,
        ),
        textTheme: GoogleFonts.syneTextTheme().apply(
          bodyColor: AppColors.white,
          displayColor: AppColors.white,
        ),
        scrollbarTheme: const ScrollbarThemeData(
          thumbVisibility: WidgetStatePropertyAll(false),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
