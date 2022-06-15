import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gob_cordoba/models/models.dart';

class UserPrefe extends ChangeNotifier {
   SharedPreferences? _prefs;
   String prefClave = 'usuario'; //clave
   String tokenVar = '';
   String idVar = '';
  // late Usuario dato1 = Usuario();


  Future init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

   Future<Usuario> userget() async{
   init();
   Usuario dato1 = Usuario();
    print('fjfjjfjfjfjf njd ');
  try {
       String? userStr =   _prefs?.getString(prefClave);
      print('22222222222222fjf njd ');
       print(userStr);
      print('22222222222222fjf njd ');

       print('qeqwweeototototoototototototoww njd ');

       Map<String, dynamic> userMap = jsonDecode(userStr!);
       dato1=Usuario.fromJson(userMap);
       print('nojdasdd');
       print(dato1.apellido2);
       print('ffkfkfkkfkfk');
  } catch (e) {
    print('j---j--');
    print('j---u--');
    print('j---o--');
    print(e);
    print('j-----');
  }
  //  print('fjfjjfjfjfjf paosododo ');

  //  Map<String, dynamic> userMap = jsonDecode(userStr!);
  //  dato1=Usuario.fromJson(userMap);
   return dato1;
  }

   set userset(Usuario value) {
     init();
     print('value.apellido2');
     print(value.apellido2);
     print('value.apellido2');
    //  _prefs?.setString(prefClave, jsonEncode(value.toJson()));
     String? userStr =   _prefs?.getString(prefClave);
       print('Malpa');
       print('ri');
       print(userStr);
       print('userStr');
  }


}

  // static String get id {
  //   return _prefs.getString(prefClave2) ?? idVar;
  // }

//   static set id(String value) {
//     idVar = value;
//     _prefs.setString(prefClave2, value);
//   }
// }



// import 'package:gob_cordoba/models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorageService {

// SharedPreferences? _sharedPreferences;

// Future<void> saveUserInfo( Usuario value ) async {
//     final Usuario user = Usuario.fromJson(value);

//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool result = await prefs.setString('user', jsonEncode(user));
//     print(result);
//   }


//   Future<User> getUserInfo() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();

//     Map<String, dynamic> userMap = {};
//     final String? userStr = prefs.getString('user');
//     if (userStr != null) {
//       userMap = jsonDecode(userStr) as Map<String, dynamic>;
//     }

//     final User user = User.fromJson(userMap);
//     print(user);
//     return user;
//   }


// FuturegetSharedPreferences () async
// {
//    // prefs = await SharedPreferences.getInstance();
// }


// }
// import 'package:gob_cordoba/models/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//  class LocalStorageService {
//    SharedPreferences? _sharedPreferences;
//     Future<LocalStorageService> init() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return this;
//   }


//   Usuario? get user{
// SharedPreferences prefs = await SharedPreferences.getInstance();
// prefs.setString('content', content);


//   }


//  }