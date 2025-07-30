import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serag_app/bloc/zikrs/zikr_competition_event.dart';
import 'package:serag_app/bloc/zikrs/zikr_competition_state.dart';

import '../../models/zikr_competition.dart';
import '../../services/zikr_competition_service.dart';

class ZikrCompetitionBloc extends Bloc<ZikrCompetitionEvent, ZikrCompetitionState> {
  final ZikrCompetitionService service;

  ZikrCompetition? _current;

  ZikrCompetitionBloc(this.service) : super(ZikrInitial()) {
    on<LoadZikrCompetition>(_onLoad);
    on<CreateZikrCompetition>(_onCreate);
    on<IncrementCount>(_onIncrement);
  }

  void _onLoad(LoadZikrCompetition event, Emitter emit) async {
    emit(ZikrLoading());
    try {
      final comp = await service.getLatestUncompletedCompetition();
      if (comp == null) {
        emit(ZikrInitial());
      } else {
        _current = comp;
        emit(ZikrLoaded(comp));
      }
    } catch (e) {
      emit(ZikrError('فشل في تحميل المسابقة'));
    }
  }

  void _onCreate(CreateZikrCompetition event, Emitter emit) async {
    try {
      final newComp = ZikrCompetition(
        id: 0,
        zikrText: event.title,
        targetCount: event.target,
        completedCount: 0,
        createdAt: DateTime.now(),
      );
      final saved = await service.createZikrCompetition(newComp);
      _current = saved;
      emit(ZikrLoaded(saved));
    } catch (e) {
      emit(ZikrError('فشل في إنشاء المسابقة'));
    }
  }

  void _onIncrement(IncrementCount event, Emitter emit) async {
    if (_current == null) return;
    if (_current!.completedCount >= _current!.targetCount) return;

    _current!.completedCount += 1;
    emit(ZikrLoaded(_current!));

    try {
      await service.updateCompletedCount(_current!.id, _current!.completedCount);

      if (_current!.completedCount >= _current!.targetCount) {
        await service.markCompetitionAsCompleted(_current!.id);
        emit(ZikrCompleted());
      }
    } catch (e) {
      emit(ZikrError('خطأ في تحديث العداد'));
    }
  }
}
