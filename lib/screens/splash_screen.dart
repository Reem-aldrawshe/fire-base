import 'package:flutter/material.dart';
import 'package:serag_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash.png', 
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:serag_app/screens/home_screen.dart';
// import 'package:serag_app/utils/fajr_helper.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   String splashImage = 'assets/images/splash.png'; // الصورة الافتراضية

//   @override
//   void initState() {
//     super.initState();
//     _loadSplashImage();

//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     });
//   }

//   Future<void> _loadSplashImage() async {
//     final isFajr = await FajrHelper.isFajrNow();
//     if (isFajr) {
//       setState(() {
//         splashImage = 'assets/images/splash2.jpg'; // ← صورة الفجر
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox.expand(
//         child: Image.asset(
//           splashImage,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
