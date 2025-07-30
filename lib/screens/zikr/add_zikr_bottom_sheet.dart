
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serag_app/models/zikr.dart';
import 'package:serag_app/services/zikr_service.dart';

class AddZikrBottomSheet extends StatefulWidget {
  final VoidCallback onAdded;

  const AddZikrBottomSheet({super.key, required this.onAdded});

  @override
  State<AddZikrBottomSheet> createState() => _AddZikrBottomSheetState();
}

class _AddZikrBottomSheetState extends State<AddZikrBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final ZikrService _zikrService = ZikrService();

  String? _selectedZikr;
  DateTimeRange? _dateRange;
  double _targetCount = 10;
  final _peopleController = TextEditingController();

  final List<String> zikrList = [
    'سبحان الله',
    'الحمد لله',
    'لا إله إلا الله',
    'الله أكبر',
    'لا حول ولا قوة إلا بالله',
  ];

  bool isLoading = false;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: now,
        end: now.add(const Duration(days: 7)),
      ),
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  Future<void> _submit() async {
    final peopleCount = int.tryParse(_peopleController.text.trim()) ?? 0;

    if (!_formKey.currentState!.validate() || _selectedZikr == null || _dateRange == null || peopleCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    final startDate = _dateRange!.start;
    final endDate = _dateRange!.end;
    final totalDays = endDate.difference(startDate).inDays + 1;
    final dailyTarget = (_targetCount / totalDays / peopleCount).ceil();

    final zikr = Zikr(
      name: _selectedZikr!,
      startDate: startDate,
      endDate: endDate,
      targetCount: _targetCount.toInt(),
      dailyTarget: dailyTarget,
    );

    setState(() => isLoading = true);
    try {
      await _zikrService.addZikr(zikr);
      widget.onAdded();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء الإضافة')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _peopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF392625), // خلفية بنية
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'الذكر',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF6B3E26),
                value: _selectedZikr,
                decoration: _inputDecoration(),
                items: zikrList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedZikr = value),
                validator: (value) => value == null ? 'الرجاء اختيار ذكر' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'مدة الختمة',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _pickDateRange,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Text(
                    _dateRange == null
                        ? 'اختر المدة'
                        : '${DateFormat('d-M-yyyy').format(_dateRange!.end)} | ${DateFormat('d-M-yyyy').format(_dateRange!.start)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'العدد المفروض',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Slider(
                value: _targetCount,
                min: 10,
                max: 1000,
                divisions: 99,
                label: _targetCount.toInt().toString(),
                activeColor: Colors.amber,
                inactiveColor: Colors.white24,
                onChanged: (value) => setState(() => _targetCount = value),
              ),

              const SizedBox(height: 16),
              const Text(
                'عدد الأشخاص',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _peopleController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(hint: 'مثلاً: 3'),
                validator: (value) => (value == null || value.isEmpty) ? 'أدخل عدد الأشخاص' : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFECDCA5),
                    foregroundColor: const Color(0xFF392625),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Color(0xFF392625))
                      : const Text('إضافة', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF6B3E26),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white30),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.amber),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
