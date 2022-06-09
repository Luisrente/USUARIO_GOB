
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gob_cordoba/models/model/getUsuario.dart';
import 'package:gob_cordoba/models/model/loginResponse.dart';
import 'package:gob_cordoba/models/user.dart';
import 'package:gob_cordoba/provider/db_provider.dart';
import 'package:gob_cordoba/services/notications_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier{

  final String _baseUrl= 'identitytoolkit.googleapis.com';
  final String _firebaseToken= 'AIzaSyAo_Tm_FOjY5D14kfDWtpF7UgNqS0xE3yU';
  final storage = new FlutterSecureStorage();
List<Usuario> usuarios = [];
  late Usuario usuario;

  Future<String> login1( String email, String password ) async {
    final data = {
      'correo': email,
      'password': password
    };
    try {
    final uri = Uri.parse('https://apigob.herokuapp.com/api/auth/login');
    final resp = await http.post(uri, 
      body: jsonEncode(data),
      headers:{
        'Content-Type': 'application/json'
      }
    );
    print('Entro metodo 1');
      if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
       SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.setString('content', jsonEncode(usuario.toJson()));
       String? w = await prefs.getString('content');
       print(w);
      await storage.write(key:'token',value:usuario.rol);  
      await storage.write(key:'id',value:usuario.id); 
      print('luis');
      if (usuario.verfi=="false" && usuario.rol=='ADMIN_ROLE'){
        await datosbase( );
        return '4';
      }
      if (usuario.verfi=="false"){
        return '1';
      }
      if (usuario.rol=='ADMIN_ROLE'){
         await datosbase( );
        return '2';
      }
      if (usuario.rol=='USER_ROLE'){
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

  Future<String> colorTheme( String id ) async {
    final data = {
      'color': id
    };

    try {
    final uri = Uri.parse('https://apigob.herokuapp.com/api/color');
    final resp = await http.post(uri, 
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
      NotificationsService.showSnackbar("Error color ");
    }
    return '';
  }

  datosbase( ) async {  
    // isLoading = true;
    notifyListeners();
    Usuario dato2 = Usuario();
    try {
    final uri = Uri.parse('https://apigob.herokuapp.com/api/usuarios');
    final resp = await http.get(uri, 
      headers: {
        'Content-Type': 'application/json'
      }
    );

    if ( resp.statusCode == 200 ) {
      print(resp);
      print('paso por el metodo base(dfdfdfdfd)');      
      final loginResponse = getsUsuarioFromJson( resp.body );
        usuarios = loginResponse.usuario;
      print(usuarios[0]);
      for (var i = 0; i < usuarios.length-1 ; i++) { 
      final s =  await DBProvider.db.nuevoScan(usuarios[i]);
      }
            final s =  await DBProvider.db.getTodosLosScans();
            print(s.length);
    } 
    } catch (e) {
      NotificationsService.showSnackbar("Comunicarse con admin base local ");
    }
  }


  Future logunt() async {
    await storage.delete(key:'token');
    await storage.delete(key:'id');
    await DBProvider.db.deleteAllScan();
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