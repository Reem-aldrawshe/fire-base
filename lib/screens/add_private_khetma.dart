import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPrivateKhetmaBottomSheet extends StatefulWidget {
  final VoidCallback onAdded;

  const AddPrivateKhetmaBottomSheet({super.key, required this.onAdded});

  @override
  State<AddPrivateKhetmaBottomSheet> createState() => _AddPrivateKhetmaBottomSheetState();
}

class _AddPrivateKhetmaBottomSheetState extends State<AddPrivateKhetmaBottomSheet> {
  final client = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();
  String? _intention;
  DateTimeRange? _dateRange;
  bool _isFajriyah = false;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: now, end: now.add(const Duration(days: 7))),
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _dateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أكمل البيانات أولاً')),
      );
      return;
    }

    await client.from('serag').insert({
      'name': _intention!,
      'intention': _intention!,
      'start_date': _dateRange!.start.toIso8601String(),
      'end_date': _dateRange!.end.toIso8601String(),
      'is_fajriyah': _isFajriyah,
      'is_public': false,
    });

    Navigator.pop(context); 
    widget.onAdded();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF372527),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(fillColor: Colors.white, filled: true, labelText: 'نية الختمة'),
                onChanged: (val) => _intention = val,
                validator: (val) => val == null || val.isEmpty ? 'أدخل النية' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDateRange,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _dateRange == null
                        ? 'اختر مدة الختمة'
                        : '${DateFormat.yMd().format(_dateRange!.start)} - ${DateFormat.yMd().format(_dateRange!.end)}',
                  ),
                ),
              ),
              Row(
                children: [
                  const Text('فجرية', style: TextStyle(color: Colors.white)),
                  Checkbox(
                    value: _isFajriyah,
                    onChanged: (val) => setState(() => _isFajriyah = val!),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('إضافة'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
