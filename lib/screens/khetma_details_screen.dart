import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/khetma.dart';

class PrivateKhetmaDetailsScreen extends StatefulWidget {
  final Khetma khatma;

  const PrivateKhetmaDetailsScreen({super.key, required this.khatma});

  @override
  State<PrivateKhetmaDetailsScreen> createState() =>
      _PrivateKhetmaDetailsScreenState();
}

class _PrivateKhetmaDetailsScreenState
    extends State<PrivateKhetmaDetailsScreen> {
  final client = Supabase.instance.client;

  List<int> reservedParts = [];
  bool loading = true;

  @override
void initState() {
  super.initState();
  print('📄 khatma id = ${widget.khatma.id}');
  _loadReservedParts();
}


  Future<void> _loadReservedParts() async {
  try {
    final response = await client
        .from('serag')
        .select('reserved_parts')
        .eq('id', widget.khatma.id!)
        .maybeSingle();

    if (response != null && response['reserved_parts'] != null) {
      final raw = (response['reserved_parts'] as String).trim();
      if (raw.isNotEmpty) {
        reservedParts = raw
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .whereType<int>()
            .toList();
      }
    }
  } catch (e) {
    debugPrint('خطأ أثناء تحميل الأجزاء: $e');
  }

  setState(() => loading = false);
}


  void _togglePart(int part) {
    if (reservedParts.contains(part)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الجزء $part محجوز مسبقاً')),
      );
    } else {
      setState(() {
        reservedParts.add(part);
      });
    }
  }

  Future<void> _saveParts() async {
    final reservedString = reservedParts.join(',');
    await client.from('serag').update({
      'reserved_parts': reservedString,
    }).eq('id', widget.khatma.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ تم حجز الأجزاء بنجاح')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffFBCB8F),
                  Color(0xffFBCB8F),
                  Color(0xffD97654),
                  Color(0xff2C1D22)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/floral.png',
                              width: 24, height: 24),
                          const SizedBox(width: 8),
                          const Text(
                            'ختمة خاصة',
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8),
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(3.1416),
                            child: Image.asset('assets/images/floral.png',
                                width: 24, height: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.khatma.intention,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/star.png',
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  '${widget.khatma.id}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 55 / 65,
                          ),
                          itemCount: 30,
                          itemBuilder: (context, index) {
                            final part = index + 1;
                            final isSelected =
                                reservedParts.contains(part);

                            return GestureDetector(
                              onTap: () => _togglePart(part),
                              child: Container(
                                width: 55,
                                height: 65,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFD5D5D5)
                                      : const Color(0xFFFFFDC3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$part',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveParts,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('حفظ'),
                          ),
                        ),
                      )
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
