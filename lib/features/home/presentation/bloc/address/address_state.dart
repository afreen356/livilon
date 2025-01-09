 class AddressChekBoxState {
   final String? selectedDocID;

  AddressChekBoxState({this.selectedDocID});
  AddressChekBoxState copyWith({String ?selectedDocID}){
   return AddressChekBoxState(selectedDocID: selectedDocID??this.selectedDocID);
  }
  bool isSelected(String docID){
    return selectedDocID == docID;
  }
}