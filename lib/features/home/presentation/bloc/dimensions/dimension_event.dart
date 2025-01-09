import 'package:livilon/features/home/domain/model/dimensionmodel.dart';

abstract class DimensionEvent {}
class AddDimensions extends DimensionEvent{
  final Dimensions dimensions;

  AddDimensions({required this.dimensions});

}