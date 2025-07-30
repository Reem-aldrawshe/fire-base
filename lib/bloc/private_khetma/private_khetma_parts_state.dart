abstract class PrivateKhetmaPartsState {}

class PrivatePartsInitial extends PrivateKhetmaPartsState {}

class PrivatePartsLoading extends PrivateKhetmaPartsState {}

class PrivatePartsLoaded extends PrivateKhetmaPartsState {
  final List<int> reservedParts;
  PrivatePartsLoaded(this.reservedParts);
}

class PrivatePartsError extends PrivateKhetmaPartsState {
  final String message;
  PrivatePartsError(this.message);
}
