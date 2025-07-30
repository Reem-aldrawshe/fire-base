abstract class KhetmaDetailsEvent {}

class LoadReservedParts extends KhetmaDetailsEvent {}

class RemindAndMarkToday extends KhetmaDetailsEvent {
  final int offset;

  RemindAndMarkToday({this.offset = 0});
}
