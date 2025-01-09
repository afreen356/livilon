import 'package:livilon/features/home/domain/model/dimensionmodel.dart';

abstract class DimensionState {}

class DimensionInitialState extends DimensionState{

}

class DimensionAddedState extends DimensionState{
  final Dimensions dimensions;

  DimensionAddedState({required this.dimensions});

}