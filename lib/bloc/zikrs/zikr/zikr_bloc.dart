import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serag_app/services/zikr_service.dart';
import 'zikr_event.dart';
import 'zikr_state.dart';

class ZikrBloc extends Bloc<ZikrEvent, ZikrState> {
  final ZikrService zikrService;

  ZikrBloc(this.zikrService) : super(ZikrInitial()) {
    on<FetchZikrs>(_onFetchZikrs);
    on<AddZikrEvent>(_onAddZikr);
    on<UpdateZikrCount>(_onUpdateZikrCount);
  }

  Future<void> _onFetchZikrs(FetchZikrs event, Emitter<ZikrState> emit) async {
    emit(ZikrLoading());
    try {
      final zikrs = await zikrService.getZikrs();
      if (zikrs.isEmpty) {
        emit(ZikrEmpty());
      } else {
        emit(ZikrLoaded(zikrs));
      }
    } catch (e) {
      emit(ZikrError('Failed to fetch zikrs: ${e.toString()}'));
    }
  }

  Future<void> _onAddZikr(AddZikrEvent event, Emitter<ZikrState> emit) async {
    try {
      await zikrService.addZikr(event.zikr);
      emit(ZikrAdded()); // إرسال حالة تشير إلى أن الذكر قد أضيف بنجاح
      add(FetchZikrs()); // إعادة جلب الأذكار لتحديث القائمة
    } catch (e) {
      emit(ZikrError('Failed to add zikr: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateZikrCount(UpdateZikrCount event, Emitter<ZikrState> emit) async {
  emit(ZikrLoading());
  try {
    await zikrService.updateZikrCompletedCount(event.zikrId, event.newCount);
    emit(ZikrCountUpdated());
    add(FetchZikrs());
  } catch (e) {
    emit(ZikrError('Failed to update zikr count: ${e.toString()}'));
  }
}

}