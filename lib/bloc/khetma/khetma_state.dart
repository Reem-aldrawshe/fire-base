import '../../models/khetma.dart';

abstract class KhetmaState {}

class KhetmaInitial extends KhetmaState {}

class KhetmaLoading extends KhetmaState {}

class KhetmaLoaded extends KhetmaState {
  final List<Khetma> khatmas;
  KhetmaLoaded(this.khatmas);
}

class KhetmaEmpty extends KhetmaState {}

class KhetmaError extends KhetmaState {
  final String message;
  KhetmaError(this.message);
}
