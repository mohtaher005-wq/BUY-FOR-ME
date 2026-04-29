import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/customer_map_screen.dart';
import 'screens/merchant_setup_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/job_search_map_screen.dart';
import 'screens/splash_wrapper.dart';
import 'providers/store_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://hrraflleindvjvaqofnz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhycmFmbGxlaW5kdmp2YXFvZm56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzMDUzOTAsImV4cCI6MjA5MDg4MTM5MH0.zH4xWI_Ey2iZnEVLSzFgExUCeKYXJlgRlpo0aGd6wFw',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()..loadFromSupabase()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const BuyForMeApp(),
    ),
  );
}

class BuyForMeApp extends StatelessWidget {
  const BuyForMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      builder: (context, localeProvider, themeProvider, child) {
        return MaterialApp(
          title: 'Buy For Me',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
            brightness: Brightness.light,
            textTheme: GoogleFonts.cairoTextTheme().copyWith(
              bodyLarge: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600),
              bodyMedium: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.normal),
              titleLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0A0F0D),
            textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
              bodyLarge: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
              bodyMedium: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white70),
              titleLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          themeMode: themeProvider.themeMode,
          locale: localeProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const SplashWrapper(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/customer-home': (context) => const CustomerMapScreen(),
            '/merchant-home': (context) => const MerchantSetupScreen(),
            '/job-search-map': (context) => const JobSearchMapScreen(),
            '/role-selection': (context) => const RoleSelectionScreen(),
            '/splash': (context) => const SplashWrapper(),
          },
        );
      },
    );
  }
}
