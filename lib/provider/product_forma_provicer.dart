
import 'package:flutter/material.dart';
import 'package:gob_cordoba/models/user.dart';

class ProductFormProvider extends ChangeNotifier {

  GlobalKey<FormState>formKey= new GlobalKey<FormState> ();

  Usuario product;

  ProductFormProvider( this.product);
  updateAvailability(bool value){
    print(value);
    notifyListeners();
  }

  bool isValidForm(){
     return formKey.currentState?.validate() ?? false;
  }
}