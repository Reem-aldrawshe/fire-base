abstract class ZikrCompetitionEvent {}

class LoadZikrCompetition extends ZikrCompetitionEvent {}

class CreateZikrCompetition extends ZikrCompetitionEvent {
  final String title;
  final int target;

  CreateZikrCompetition(this.title, this.target);
}

class IncrementCount extends ZikrCompetitionEvent {}
