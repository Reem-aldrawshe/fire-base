
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/khetma.dart';

class ManageKhetmaBottomSheet extends StatefulWidget {
  final Khetma khetma;

  const ManageKhetmaBottomSheet({super.key, required this.khetma});

  @override
  State<ManageKhetmaBottomSheet> createState() => _ManageKhetmaBottomSheetState();
}

class _ManageKhetmaBottomSheetState extends State<ManageKhetmaBottomSheet> {
  final client = Supabase.instance.client;

  final _peopleController = TextEditingController();
  final _namesController = TextEditingController();

  bool isLoading = false;

  Future<void> _shareAndSave() async {
    setState(() => isLoading = true);

    final peopleCount = int.tryParse(_peopleController.text.trim()) ?? 0;
    final names = _namesController.text.trim();

    if (peopleCount <= 0 || names.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل عدد الأشخاص وأسمائهم')),
      );
      setState(() => isLoading = false);
      return;
    }

    if (widget.khetma.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('معرف الختمة غير موجود')),
      );
      setState(() => isLoading = false);
      return;
    }

    final totalParts = 30;
    final totalDays = widget.khetma.endDate.difference(widget.khetma.startDate).inDays + 1;

    // حساب أجزاء اليوم بناءً على اليوم الحالي
    final now = DateTime.now();
    final startDate = widget.khetma.startDate;
    int dayIndex = now.difference(startDate).inDays + 1;

    if (dayIndex < 1) dayIndex = 1;
    if (dayIndex > totalDays) dayIndex = totalDays;

    // أجزاء لكل يوم (تقسيم متساوي)
    final partsPerDay = (totalParts / totalDays).ceil();

    // حساب الأجزاء لليوم الحالي
    final int startPart = (dayIndex - 1) * partsPerDay + 1;
    int endPart = startPart + partsPerDay - 1;
    if (endPart > totalParts) endPart = totalParts;

    // حساب توزيع الأجزاء على الأشخاص (متساوي لكل شخص)
    final partsCountToday = endPart - startPart + 1;
    final partsPerPerson = (partsCountToday / peopleCount).ceil();

    // أجزاء اليوم الكاملة
    final todaysParts = <int>[];
    int currentPart = startPart;

    for (int i = 0; i < peopleCount; i++) {
      for (int j = 0; j < partsPerPerson; j++) {
        if (currentPart <= endPart) {
          todaysParts.add(currentPart);
          currentPart++;
        }
      }
    }

    // نص الأجزاء المعلمة
    final reservedString = todaysParts.join(',');

    // تحديث بيانات الختمة في Supabase مع حفظ الأجزاء والأسماء والعدد
    final khetmaId = widget.khetma.id;

    if (khetmaId == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('⚠️ معرف الختمة غير موجود!')),
  );
  setState(() => isLoading = false);
  return;
}

    await client.from('serag').update({
      'reserved_parts': reservedString,
      'people_count': peopleCount,
      'names': names,
    }).eq('id', khetmaId);

    // رسالة واتساب للإرسال
    final message = '''
📖 ختمة "${widget.khetma.name}"
الأجزاء لليوم: ${todaysParts.join(', ')}
الأشخاص: $names
''';

    final url = Uri.parse('https://wa.me/?text=${Uri.encodeFull(message)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }

    setState(() => isLoading = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF372527),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'عدد الأشخاص',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _peopleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'أسماء الأشخاص',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _namesController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _shareAndSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F1E5),
                  foregroundColor: const Color(0xff442B0D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'إنشاء ومشاركة',
                        style: TextStyle(fontSize: 20),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
