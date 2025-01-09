abstract class AddressCheckBoxEvent {
  
}

class SelectedAddressBox extends AddressCheckBoxEvent{
    final String docId;

  SelectedAddressBox({required this.docId});
}