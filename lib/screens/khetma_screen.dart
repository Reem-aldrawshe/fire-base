import 'package:flutter/material.dart';
import 'package:serag_app/models/khetma.dart';
import 'package:serag_app/screens/add_khetma.dart';
import 'package:serag_app/services/khetma_service.dart';

class KhetmaScreen extends StatefulWidget {
  const KhetmaScreen({super.key});

  @override
  State<KhetmaScreen> createState() => _KhetmaScreenState();
}

class _KhetmaScreenState extends State<KhetmaScreen> {
  final _service = KhetmaService();
  late Future<List<Khetma>> _futureKhatmas;

  @override
  void initState() {
    super.initState();
    _futureKhatmas = _service.getKhetmas();
  }

  void _refresh() {
    setState(() {
      _futureKhatmas = _service.getKhetmas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/floral.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text(
              'الختمات',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.1416),
              child: Image.asset('assets/images/floral.png', width: 24, height: 24),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Khetma>>(
        future: _futureKhatmas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ أثناء جلب البيانات'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد ختمات بعد'));
          }

          final khatmas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: khatmas.length,
            itemBuilder: (context, index) {
              final khatma = khatmas[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFE5D4B0),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(khatma.name),
                  subtitle: Text('من ${khatma.startDate} إلى ${khatma.endDate}'),
                  onTap: () {
                    // صفحة التفاصيل لاحقاً
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6B3E26),
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddKhetma(onAdded: _refresh),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
