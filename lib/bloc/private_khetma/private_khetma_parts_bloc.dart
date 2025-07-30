import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/khetma.dart';
import 'private_khetma_parts_event.dart';
import 'private_khetma_parts_state.dart';

class PrivateKhetmaPartsBloc
    extends Bloc<PrivateKhetmaPartsEvent, PrivateKhetmaPartsState> {
  final SupabaseClient client;
  final Khetma khatma;

  PrivateKhetmaPartsBloc(this.client, this.khatma) : super(PrivatePartsInitial()) {
    on<LoadPrivateReservedParts>(_onLoad);
    on<UpdatePrivateReservedParts>(_onUpdate);
  }

  Future<void> _onLoad(
      LoadPrivateReservedParts event, Emitter emit) async {
    emit(PrivatePartsLoading());
    try {
      final response = await client
          .from('serag')
          .select('reserved_parts')
          .eq('id', khatma.id!)
          .maybeSingle();

      List<int> reserved = [];
      final raw = response?['reserved_parts'] ?? '';
      if (raw.toString().trim().isNotEmpty) {
        reserved = raw
            .toString()
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .whereType<int>()
            .toList();
      }

      emit(PrivatePartsLoaded(reserved));
    } catch (e) {
      emit(PrivatePartsError('فشل تحميل الأجزاء'));
    }
  }

  Future<void> _onUpdate(
      UpdatePrivateReservedParts event, Emitter emit) async {
    emit(PrivatePartsLoading());
    try {
      final reservedString = event.selectedParts.join(',');

      await client.from('serag').update({
        'reserved_parts': reservedString,
      }).eq('id', khatma.id!);

      emit(PrivatePartsLoaded(event.selectedParts));
    } catch (e) {
      emit(PrivatePartsError('فشل حفظ الأجزاء'));
    }
  }
}
