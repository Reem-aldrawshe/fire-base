import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:serag_app/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");


 await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );
  
  // await Supabase.initialize(
  //   url:'https://fbwrjmdctrboqjxywjfv.supabase.co',
  //   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZid3JqbWRjdHJib3FqeHl3amZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2MDg1MzMsImV4cCI6MjA2ODE4NDUzM30.b_4Tt7vszMWjZVBiPqLRPVZaZHjuHd2eOLL_aeYVEKo',
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'package:serag_app/screens/splash_screen.dart';
// import 'package:serag_app/theme/app_theme.dart';
// import 'package:serag_app/theme/theme_notifier.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();


//   await dotenv.load(fileName: ".env");

//   final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
//   final supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';

//   await Supabase.initialize(
//     url: supabaseUrl,
//     anonKey: supabaseKey,
//   );

//   final themeNotifier = ThemeNotifier();
//   await themeNotifier.checkTimeAndUpdateTheme();

//   runApp(
//     ChangeNotifierProvider.value(
//       value: themeNotifier,
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeNotifier>(
//       builder: (context, theme, _) {
//         return MaterialApp(
//              debugShowCheckedModeBanner: false,
//           theme: AppTheme.lightTheme,   // ← الثيم الفجر
//           darkTheme: AppTheme.darkTheme, // ← الثيم البني
//           themeMode: theme.mode,
//           home: const SplashScreen(),
//         );
//       },
//     );
//   }
// }
