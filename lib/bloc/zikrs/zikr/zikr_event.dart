import 'package:equatable/equatable.dart';
import 'package:serag_app/models/zikr.dart';

abstract class ZikrEvent extends Equatable {
  const ZikrEvent();

  @override
  List<Object?> get props => [];
}

class FetchZikrs extends ZikrEvent {}

class AddZikrEvent extends ZikrEvent {
  final Zikr zikr;

  const AddZikrEvent(this.zikr);

  @override
  List<Object?> get props => [zikr];
}

class UpdateZikrCount extends ZikrEvent {
  final int zikrId;
  final int newCount;

  const UpdateZikrCount(this.zikrId, this.newCount);

  @override
  List<Object?> get props => [zikrId, newCount];
}