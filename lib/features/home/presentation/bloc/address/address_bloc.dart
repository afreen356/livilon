import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/address/address_event.dart';
import 'package:livilon/features/home/presentation/bloc/address/address_state.dart';

class AddressCheckBoxBloc extends  Bloc<AddressCheckBoxEvent, AddressChekBoxState> {
  AddressCheckBoxBloc() : super(AddressChekBoxState()) {
    on<SelectedAddressBox>((event, emit) {
      if (state.selectedDocID==event.docId) {
        emit(AddressChekBoxState(selectedDocID: null));
      }else{
        emit(AddressChekBoxState(selectedDocID: event.docId));
      }
    });
  }
}