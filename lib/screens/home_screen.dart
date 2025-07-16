import 'package:flutter/material.dart';
import 'package:serag_app/screens/khetma_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool showTasbeehOptions = false;
  bool showKhetmaOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0A96D), Color(0xFF6B3E26)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/floral.png',
                        width: 24, height: 24),
                    SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "سراج",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5C3B13),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.rotationY(3.1416), // لقلب الصورة أفقياً
                      child: Image.asset('assets/images/floral.png',
                          width: 24, height: 24),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'المستخدم عند الفجر يعرض فقط \n الأوراد و الختم الفجرية ،\n و ما بقي من اليوم يعرض الأوراد و \n الختم الاخرى',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff5C3B13)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    top: -16,
                    right: 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/star.png',
                          width: 68,
                          height: 50,
                        ),
                        Text(
                          'ملاحظة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF372527),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCircle('assets/images/tasbeeh.png', 'تسبيح', () {
                      setState(() {
                        showTasbeehOptions = !showTasbeehOptions;
                        showKhetmaOptions = false;
                      });
                    }),
                    _buildCircle('assets/images/quran.png', 'سورة', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const PlaceholderScreen(title: 'سورة'),
                        ),
                      );
                    }),
                    _buildCircle('assets/images/khetma.png', 'ختمة', () {
                      setState(() {
                        showKhetmaOptions = !showKhetmaOptions;
                        showTasbeehOptions = false;
                      });
                    }),
                  ],
                ),
              ),
              if (showTasbeehOptions) ...[
                const SizedBox(height: 10),
                _buildSubCircle('assets/images/meeting.png', 'جلسة ذكر', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PlaceholderScreen(title: 'جلسة ذكر'),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                _buildSubCircle('assets/images/counter.png', 'مسابقة ذكر', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PlaceholderScreen(title: 'مسابقة ذكر'),
                    ),
                  );
                }),
              ],
              if (showKhetmaOptions) ...[
                const SizedBox(height: 10),
                _buildSubCircle('assets/images/private.png', 'ختمة خاصة', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PlaceholderScreen(title: 'ختمة خاصة'),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                _buildSubCircle('assets/images/public.png', 'ختمة عامة', () {
                  Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const KhetmaScreen()),
);

                }),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(String image, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, width: 30, height: 30),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff412B2D),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubCircle(String image, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, width: 20, height: 20),
              const SizedBox(height: 2),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff412B2D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('شاشة $title')),
    );
  }
}
