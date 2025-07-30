import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/khetma.dart';
import 'khetma_details_event.dart';
import 'khetma_details_state.dart';

class KhetmaDetailsBloc extends Bloc<KhetmaDetailsEvent, KhetmaDetailsState> {
  final SupabaseClient client;
  Khetma khatma;

  KhetmaDetailsBloc(this.client, this.khatma) : super(KhetmaInitial()) {
    on<LoadReservedParts>(_onLoadReservedParts);
    on<RemindAndMarkToday>(_onRemindAndMarkToday);
  }

  Future<void> _onLoadReservedParts(
      LoadReservedParts event, Emitter emit) async {
    emit(KhetmaLoading());
    try {
      final response = await client
          .from('serag')
          .select()
          .eq('id', khatma.id!)
          .maybeSingle();

      if (response == null) {
        emit(KhetmaError('الختمة غير موجودة'));
        return;
      }

      List<int> reservedParts = [];
      final raw = (response['reserved_parts'] ?? '').toString().trim();
      if (raw.isNotEmpty) {
        reservedParts = raw
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .whereType<int>()
            .toList();
      }

      // حدث نسخة الختمة مع البيانات الجديدة
      khatma = khatma.copyWith(
        names: response['names']?.toString(),
        peopleCount: response['people_count'] ?? 0,
      );

      emit(KhetmaLoaded(khatma, reservedParts));
    } catch (e) {
      emit(KhetmaError('خطأ أثناء تحميل الأجزاء'));
    }
  }

 Future<void> _onRemindAndMarkToday(
    RemindAndMarkToday event, Emitter emit) async {
  emit(KhetmaLoading());
  try {
    final totalParts = 30;
    final offset = event.offset;
    final totalDays = khatma.endDate.difference(khatma.startDate).inDays + 1;

    final todayIndex = DateTime.now().difference(khatma.startDate).inDays + offset;

    if (todayIndex >= totalDays) {
      emit(KhetmaFinished('انتهت مدة الختمة'));
      return;
    }

    final peopleCount = khatma.peopleCount ?? 0;
    if (peopleCount == 0) {
      emit(KhetmaFinished('لا يوجد أشخاص للختمة'));
      return;
    }

    final partsPerDay = (totalParts / totalDays).ceil();
    final startPartToday = todayIndex * partsPerDay + 1;
    final endPartToday = (startPartToday + partsPerDay - 1).clamp(1, 30);

    final todaysParts =
        List.generate(endPartToday - startPartToday + 1, (i) => startPartToday + i);

    final message = '''
📖 ختمة "${khatma.name}"
الأجزاء لليوم: ${todaysParts.join(', ')}
الأشخاص: ${khatma.names}
''';

    final url = Uri.parse('https://wa.me/?text=${Uri.encodeFull(message)}');

    if (await canLaunchUrl(url)) {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (launched) {
        // هنا نقرأ reserved_parts مجدداً من القاعدة لضمان الدقة
        final response = await client
            .from('serag')
            .select('reserved_parts')
            .eq('id', khatma.id!)
            .maybeSingle();

        List<int> reservedParts = [];
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

        final updatedParts = {...reservedParts, ...todaysParts}.toList()..sort();
        final reservedString = updatedParts.join(',');

        await client.from('serag').update({
          'reserved_parts': reservedString,
        }).eq('id', khatma.id!);

        // حدث الحالة مع الأجزاء الجديدة
        emit(KhetmaLoaded(khatma, updatedParts));
      }
    }
  } catch (e) {
    emit(KhetmaError('خطأ أثناء إرسال التذكير'));
  }
}

}
