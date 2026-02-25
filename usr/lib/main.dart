import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'integrations/supabase.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  // Note: Even if keys are invalid/missing in the config, the app will launch.
  // Real AI/Payment features would require valid keys and Edge Functions.
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const AgentForgeApp());
}

class AgentForgeApp extends StatelessWidget {
  const AgentForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'AgentForge',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF00E5FF), // Cyan/Neon Blue
            secondary: const Color(0xFF2979FF),
            surface: const Color(0xFF121212),
            background: const Color(0xFF0A0A0A),
            onPrimary: Colors.black,
          ),
          textTheme: GoogleFonts.jetbrainsMonoTextTheme(
            ThemeData.dark().textTheme,
          ),
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
