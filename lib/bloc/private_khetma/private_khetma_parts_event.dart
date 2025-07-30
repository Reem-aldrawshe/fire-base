abstract class PrivateKhetmaPartsEvent {}

class LoadPrivateReservedParts extends PrivateKhetmaPartsEvent {}

class UpdatePrivateReservedParts extends PrivateKhetmaPartsEvent {
  final List<int> selectedParts;
  UpdatePrivateReservedParts(this.selectedParts);
}
