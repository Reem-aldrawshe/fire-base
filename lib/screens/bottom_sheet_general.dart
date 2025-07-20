import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:serag_app/models/khetma.dart';

class ManageKhetmaBottomSheet extends StatefulWidget {
  final Khetma khetma;

  const ManageKhetmaBottomSheet({super.key, required this.khetma});

  @override
  State<ManageKhetmaBottomSheet> createState() => _ManageKhetmaBottomSheetState();
}

class _ManageKhetmaBottomSheetState extends State<ManageKhetmaBottomSheet> {
  final _peopleController = TextEditingController();
  final _namesController = TextEditingController();
  int? _selectedParts;

  Future<void> _shareWhatsApp() async {
    final message =
        'ختمة "${widget.khetma.name}"\nعدد الأشخاص: ${_peopleController.text}\nالأسماء: ${_namesController.text}\nعدد الأجزاء لكل شخص: ${_selectedParts ?? '-'}';
    final url = Uri.parse('https://wa.me/?text=${Uri.encodeFull(message)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح واتساب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFF372527),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'عدد الأشخاص',
                style: TextStyle(color: Color(0xffFFFDC3), fontSize: 23, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _peopleController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'اسماء المشتركين',
                style: TextStyle(color: Color(0xffFFFDC3), fontSize: 23, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _namesController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'عدد الأجزاء لكل شخص',
                style: TextStyle(color: Color(0xffFFFDC3), fontSize: 23, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 8),

            Column(
  children: List.generate(3, (index) {
    final part = index + 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$part',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Checkbox(
          value: _selectedParts == part,
          onChanged: (_) {
            setState(() => _selectedParts = part);
          },
          side: const BorderSide(color: Colors.white),
          checkColor: const Color(0xFF372527),
          activeColor: Colors.white,
        ),
      ],
    );
  }),
),


            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _shareWhatsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F1E5),
                  foregroundColor: const Color(0xff442B0D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إنشاء ومشاركة',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25, color: Color(0xff442B0D)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
