
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gob_cordoba/models/model/loginResponse.dart';
import 'package:gob_cordoba/models/user.dart';
import 'package:gob_cordoba/services/notications_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier{

  final String _baseUrl= 'identitytoolkit.googleapis.com';
  final String _firebaseToken= 'AIzaSyAo_Tm_FOjY5D14kfDWtpF7UgNqS0xE3yU';
  final storage = new FlutterSecureStorage();

  late Usuario usuario;


  Future<String?> createUser(String email, String password ) async{
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
    await login1(email,password);
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

  Future<String> login1( String email, String password ) async {
    final data = {
      'correo': email,
      'password': password
    };
    try {
    final uri = Uri.parse('https://apigob.herokuapp.com/api/auth/login');
    final resp = await http.post(uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
      if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
       SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.setString('content', jsonEncode(usuario.toJson()));
       String? w = await prefs.getString('content');
       print(w);


      await storage.write(key:'token',value:usuario.rol);  
      await storage.write(key:'id',value:usuario.id);    
      if (usuario.verfi=="false"){
        return '1';
      }
      if (usuario.estado=="true" && usuario.rol=='ADMIN_ROLE'){
        return '2';
      }
      if (usuario.estado=="true" && usuario.rol=='USER_ROLE' ){
        return '3';
      }
      // await this._guardarToken(loginResponse.token);
    } else {
      final respBody = jsonDecode(resp.body);
      NotificationsService.showSnackbar(respBody['msg']);
      return '';
    }
    } catch (e) {
      NotificationsService.showSnackbar("Comunicarse con el admin ");
    }
    return '';
  }

   Future<String> password( String password,String id ) async {
    final data = {
      'password': password
    };
    try {
    final uri = Uri.parse('https://apigob.herokuapp.com/api/usuarios/${id}');
    final resp = await http.put(uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    print('paso');
    if ( resp.statusCode == 200 ) {
      print('entro');
      return '1';
      // await this._guardarToken(loginResponse.token);
    } else {
      final respBody = jsonDecode(resp.body);
      NotificationsService.showSnackbar(respBody['msg']);
      return '';
    }
    } catch (e) {
      NotificationsService.showSnackbar("Comunicarse con el admin ");
    }
    return '';
  }


  Future logunt() async {
    await storage.delete(key:'token');
    await storage.delete(key:'email');
    await storage.delete(key:'name');
    await storage.delete(key:'document');
    return;
  }

 Future<String> readToken()async{
  return  await storage.read(key:'token') ?? '';
  }

 Future<String> readId()async{
  return  await storage.read(key:'id') ?? '';
  }

  Future<String>readData()async{
  return  await storage.read(key:'email') ?? '';
  }

}