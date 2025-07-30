import '../../models/zikr_competition.dart';

abstract class ZikrCompetitionState {}

class ZikrInitial extends ZikrCompetitionState {}

class ZikrLoading extends ZikrCompetitionState {}

class ZikrLoaded extends ZikrCompetitionState {
  final ZikrCompetition competition;
  ZikrLoaded(this.competition);
}

class ZikrCompleted extends ZikrCompetitionState {}

class ZikrError extends ZikrCompetitionState {
  final String message;
  ZikrError(this.message);
}
