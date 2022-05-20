
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier{

  final String _baseUrl= 'identitytoolkit.googleapis.com';
  final String _firebaseToken= 'AIzaSyAo_Tm_FOjY5D14kfDWtpF7UgNqS0xE3yU';
  final storage = new FlutterSecureStorage();

  Future<String?> createUser(String email, String password ) async{
    // final Map<String , dynamic> authData= {
    //   'email': email,
    //   'password': password,
    //   'returnSecureToken': true
    // };
    final Map<String , dynamic> authData= {
      'email': email,
      'password': password,
    };


    final url= Uri.https(_baseUrl, '/v1/accounts:signUp',{
      'key': _firebaseToken
    });
    final resp= await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if(decodedResp.containsKey('idToken')){
      //Token hay que guardarlo en un lugar seguro
      await storage.write(key:'token',value:decodedResp['idToken']);
      return null;
    }else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password ) async{
    final Map<String , dynamic> authData= {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final url= Uri.https(_baseUrl, '/v1/accounts:signInWithPassword',{
      'key': _firebaseToken
    });
    final resp= await http.post(url, body: json.encode(authData));
    
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if(decodedResp.containsKey('idToken')){
      //Token hay que guardarlo en un lugar seguro
      await storage.write(key:'email',value:email);

      print('Guardo en el storage');
      
      await storage.write(key:'token',value:decodedResp['idToken']);      
      return null;
    }else {
      return decodedResp['error']['message'];
    }
  }

  Future logunt() async {
    await storage.delete(key:'token');
    await storage.delete(key:'email');
    await storage.delete(key:'name');
    return;
  }

 Future<String> readToken()async{
  return  await storage.read(key:'token') ?? '';
  }


  Future<String>readData()async{
  return  await storage.read(key:'email') ?? '';
  }
}