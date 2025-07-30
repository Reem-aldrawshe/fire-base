import 'package:flutter_bloc/flutter_bloc.dart';
import 'khetma_event.dart';
import 'khetma_state.dart';
import '../../services/khetma_service.dart';

class KhetmaBloc extends Bloc<KhetmaEvent, KhetmaState> {
  final KhetmaService service;

  KhetmaBloc(this.service) : super(KhetmaInitial()) {
    on<FetchKhetmas>((event, emit) async {
      emit(KhetmaLoading());
      try {
        final khatmas = await service.getKhetmas(isPublic: event.isPublic);
        if (khatmas.isEmpty) {
          emit(KhetmaEmpty());
        } else {
          emit(KhetmaLoaded(khatmas));
        }
      } catch (_) {
        emit(KhetmaError('حدث خطأ أثناء تحميل الختمات'));
      }
    });
  }
}
