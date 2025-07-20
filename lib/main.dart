import 'package:flutter/material.dart';
import 'package:serag_app/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:'https://fbwrjmdctrboqjxywjfv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZid3JqbWRjdHJib3FqeHl3amZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2MDg1MzMsImV4cCI6MjA2ODE4NDUzM30.b_4Tt7vszMWjZVBiPqLRPVZaZHjuHd2eOLL_aeYVEKo',
  );

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
