import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serag_app/models/khetma.dart';
import 'package:serag_app/services/khetma_service.dart';

class AddKhetma extends StatefulWidget {
  final VoidCallback onAdded;

  const AddKhetma({super.key, required this.onAdded});

  @override
  State<AddKhetma> createState() => _AddKhetmaState();
}

class _AddKhetmaState extends State<AddKhetma> {
  final _formKey = GlobalKey<FormState>();
  final _service = KhetmaService();

  String? _intention;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isFajriyah = false;
  bool _isPriority = false;

  final List<String> _intentions = [
    'عن روح مسلم',
    'قضاء حاجة',
    'تفريج هم',
    'تيسير أمر',
  ];

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر تاريخ البداية والنهاية')),
      );
      return;
    }

    final khetma = Khetma(
      name: _intention!,
      intention: _intention!,
      startDate: _startDate!,
      endDate: _endDate!,
      isFajriyah: _isFajriyah,
      isPriority: _isPriority,
    );

    await _service.addKhetma(khetma);

    widget.onAdded();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'إضافة ختمة جديدة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'النية',
                  border: OutlineInputBorder(),
                ),
                items: _intentions
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (val) => _intention = val,
                validator: (val) => val == null ? 'اختر النية' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickDate(isStart: true),
                      child: Text(
                        _startDate == null
                            ? 'تاريخ البداية'
                            : DateFormat.yMd().format(_startDate!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickDate(isStart: false),
                      child: Text(
                        _endDate == null
                            ? 'تاريخ النهاية'
                            : DateFormat.yMd().format(_endDate!),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _isFajriyah,
                onChanged: (val) => setState(() => _isFajriyah = val!),
                title: const Text('فجرية'),
              ),
              CheckboxListTile(
                value: _isPriority,
                onChanged: (val) => setState(() => _isPriority = val!),
                title: const Text('ذات أولوية'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B3E26),
                ),
                child: const Text(
                  'إضافة',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
