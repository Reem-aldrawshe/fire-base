import 'package:flutter/material.dart';

class CreateCompetitionDialog extends StatefulWidget {
  final Function(String title, int target) onCreate;

  const CreateCompetitionDialog({super.key, required this.onCreate});

  @override
  State<CreateCompetitionDialog> createState() => _CreateCompetitionDialogState();
}

class _CreateCompetitionDialogState extends State<CreateCompetitionDialog> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF9F5F0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'إنشاء مسابقة ذكر جديدة',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xff5C3B13),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: 'عنوان الذكر (مثلاً: سبحان الله)',
                labelStyle: const TextStyle(color: Color(0xff5C3B13)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال عنوان الذكر';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _targetController,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'العدد الكلي للهدف',
                labelStyle: const TextStyle(color: Color(0xff5C3B13)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'أدخل العدد';
                }
                final intValue = int.tryParse(value);
                if (intValue == null || intValue <= 0) {
                  return 'أدخل عددًا صحيحًا موجبًا';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final title = _titleController.text.trim();
                  final target = int.parse(_targetController.text.trim());
                  widget.onCreate(title, target);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD6B287),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'بدء المسابقة',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
