import 'package:equatable/equatable.dart';
import 'package:serag_app/models/zikr.dart';

abstract class ZikrState extends Equatable {
  const ZikrState();

  @override
  List<Object> get props => [];
}

class ZikrInitial extends ZikrState {}

class ZikrLoading extends ZikrState {}

class ZikrLoaded extends ZikrState {
  final List<Zikr> zikrs;

  const ZikrLoaded(this.zikrs);

  @override
  List<Object> get props => [zikrs];
}

class ZikrEmpty extends ZikrState {}

class ZikrError extends ZikrState {
  final String message;

  const ZikrError(this.message);

  @override
  List<Object> get props => [message];
}

class ZikrAdded extends ZikrState {}
class ZikrCountUpdated extends ZikrState {}