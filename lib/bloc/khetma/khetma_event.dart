abstract class KhetmaEvent {}

class FetchKhetmas extends KhetmaEvent {
  final bool isPublic; 
  FetchKhetmas({required this.isPublic});
}
