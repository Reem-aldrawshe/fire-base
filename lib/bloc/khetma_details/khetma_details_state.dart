import 'package:serag_app/models/khetma.dart';

abstract class KhetmaDetailsState {}

class KhetmaInitial extends KhetmaDetailsState {}

class KhetmaLoading extends KhetmaDetailsState {}

class KhetmaLoaded extends KhetmaDetailsState {
  final Khetma khatma;
  final List<int> reservedParts;

  KhetmaLoaded(this.khatma, this.reservedParts);
}

class KhetmaError extends KhetmaDetailsState {
  final String message;

  KhetmaError(this.message);
}

class KhetmaFinished extends KhetmaDetailsState {
  final String message;

  KhetmaFinished(this.message);
}
