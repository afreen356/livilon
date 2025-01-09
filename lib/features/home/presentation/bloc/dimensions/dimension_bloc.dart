 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/dimensions/dimension_event.dart';
import 'package:livilon/features/home/presentation/bloc/dimensions/dimension_state.dart';

class DimensionBloc extends  Bloc<DimensionEvent, DimensionState> {
  DimensionBloc() : super(DimensionInitialState()) {
    on<AddDimensions>((event,emit){
      emit(DimensionAddedState(dimensions: event.dimensions));
    });
  }
 }