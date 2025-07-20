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
  DateTimeRange? _dateRange;
  bool _isFajriyah = false;
  bool _isPublic = false;

  final List<String> _intentions = [
    'عن روح مسلم',
    'قضاء حاجة',
    'تفريج هم',
    'تيسير أمر',
  ];

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
    if (!_formKey.currentState!.validate()) return;
    if (_dateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر مدة الختمة')),
      );
      return;
    }

    final khetma = Khetma(
      name: _intention!,
      intention: _intention!,
      startDate: _dateRange!.start,
      endDate: _dateRange!.end,
      isFajriyah: _isFajriyah,
      isPublic: _isPublic,
    );

    final id = await _service.addKhetma(khetma);
final completeKhetma = khetma.copyWith(id: id);


    if (!mounted) return;

    // 🔷 ترجع للصفحة الرئيسية
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ تمت إضافة الختمة برقم: $id')),
    );

    widget.onAdded();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF372527),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'النية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                items: _intentions
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (val) => _intention = val,
                validator: (val) => val == null ? 'اختر النية' : null,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'مدة الختمة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: _pickDateRange,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Text(
                    _dateRange == null
                        ? ''
                        : '${DateFormat.yMd().format(_dateRange!.start)} - ${DateFormat.yMd().format(_dateRange!.end)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      const Text(
                        'ذات أولوية',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Checkbox(
                        value: _isPublic,
                        onChanged: (val) => setState(() => _isPublic = val!),
                        side: const BorderSide(color: Colors.white),
                        checkColor: const Color(0xFF372527),
                        activeColor: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      const Text(
                        'فجرية',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Checkbox(
                        value: _isFajriyah,
                        onChanged: (val) => setState(() => _isFajriyah = val!),
                        side: const BorderSide(color: Colors.white),
                        checkColor: const Color(0xFF372527),
                        activeColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8F1E5),
                    foregroundColor: const Color(0xff442B0D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'إضافة',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
