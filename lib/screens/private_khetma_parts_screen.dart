import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/khetma.dart';

class PrivateKhetmaPartsScreen extends StatefulWidget {
  final Khetma khatma;

  const PrivateKhetmaPartsScreen({super.key, required this.khatma});

  @override
  State<PrivateKhetmaPartsScreen> createState() => _PrivateKhetmaPartsScreenState();
}

class _PrivateKhetmaPartsScreenState extends State<PrivateKhetmaPartsScreen> {
  final client = Supabase.instance.client;

  List<int> reservedParts = [];
  List<int> selectedParts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadReservedParts();
  }

  Future<void> _loadReservedParts() async {
    final response = await client
        .from('serag')
        .select('reserved_parts')
        .eq('id', widget.khatma.id!)
        .maybeSingle();

    if (response != null && response['reserved_parts'] != null) {
      final raw = response['reserved_parts'].toString();
      reservedParts = raw
          .split(',')
          .map((e) => int.tryParse(e.trim()))
          .whereType<int>()
          .toList();
    }

    setState(() => loading = false);
  }

  void _togglePart(int part) {
    if (reservedParts.contains(part)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الجزء محجوز مسبقاً')),
      );
      return;
    }

    setState(() {
      if (selectedParts.contains(part)) {
        selectedParts.remove(part);
      } else {
        selectedParts.add(part);
      }
    });
  }

  Future<void> _save() async {
    final updatedParts = {...reservedParts, ...selectedParts}.toList()..sort();
    final reservedString = updatedParts.join(',');

    await client.from('serag').update({
      'reserved_parts': reservedString,
    }).eq('id', widget.khatma.id!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الأجزاء')),
    );

    setState(() {
      reservedParts = updatedParts;
      selectedParts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDEBD0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B3E26),
        title: const Text('اختيار الأجزاء'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        final part = index + 1;
                        final isReserved = reservedParts.contains(part);
                        final isSelected = selectedParts.contains(part);

                        Color color;
                        if (isReserved) {
                          color = Colors.grey; // محجوز
                        } else if (isSelected) {
                          color = const Color(0xffC7B7A3); // محدد 
                        } else {
                          color = const Color(0xffF7E1A1); 
                        }

                        return GestureDetector(
                          onTap: () => _togglePart(part),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('$part'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B3E26),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _save,
                      child: const Text(
                        'حفظ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
