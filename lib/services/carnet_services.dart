import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;



import 'package:shared_preferences/shared_preferences.dart';


import 'package:gob_cordoba/shared_prefe/preferencias_user.dart';
import 'package:gob_cordoba/provider/provider.dart';
import 'package:gob_cordoba/models/models.dart';
import 'package:gob_cordoba/services/services.dart';



class CarnetService extends ChangeNotifier{

  final storage = FlutterSecureStorage();
  List<Usuario> usuarios = [];
  late Usuario usuario;
  late Usuario usualiorSelect;
  Usuario selectedProduct= Usuario();
  final prefe= UserPrefe();


  File? newPictureFile;


  bool isLoading = false;
  bool isSaving = false;

  CarnetService(){
    this.loadCartUser();
  }

 Future<String>readData()async{
  return  await storage.read(key:'data') ?? '';
  }


 Future <Usuario> loadCartUser() async {


  Usuario dato1 = Usuario();
  Usuario dato3 = Usuario();
  print('loadCartUser');
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String? kitJson = prefs.getString("content");
    final String? userStr = prefs.getString('content');
    print('--------------------------');
    print('--------------------------');

    if (userStr != null) {
      print('entro');
      Map<String, dynamic> userMap = jsonDecode(userStr);
      dato1=Usuario.fromJson(userMap);
    }

    try {
    final uri = Uri.parse('https://apigob.herokuapp.com/api/usuarios/${dato1.documento}');
    final resp = await http.get(uri, 
      headers: {
        'Content-Type': 'application/json'
      }
    );
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      // selectedProduct.img=usuario.img;
      
      prefe.userset=usuario;

      return usuario;
    } else {
      dato1=usuario;
      // selectedProduct.img=usuario.img;
      return usuario;
    }
    } catch (e) {
      print('kemkkmeemkmekmke');
      print(e);
      print('ejjejejejjej');
      NotificationsService.showSnackbar("Comunicarse con el admin loadcard ");
      return dato1;
  }
   }

  Future <Usuario> loadCarstAdmin( String id) async {
    isLoading = true;
    notifyListeners();
    Usuario dato1 = Usuario();
    // datosbase( );
    try {
    final uri = Uri.parse('https://apigob.herokuapp.com/api/usuarios/${id}');
    final resp = await http.get(uri, 
      headers: {
        'Content-Type': 'application/json'
      }
    );
    print('paso');
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;
      usualiorSelect=usuario;
      return usuario;
    } else {
    }
    } catch (e) {
     final Usuario scans= await DBProvider.db.getScanById(id);
     if(scans.apellido1==null){
       print('null');
     }else{
       usualiorSelect=scans;
       return scans;
     } 
    }
    return dato1;
  }


   Future  loadControlAdmin( Control control ) async {
    isLoading = true;
    notifyListeners();
    Usuario dato1 = Usuario();
    try {
    final uri = Uri.parse('https://apigob.herokuapp.com/api/control');
    final resp = await http.post(uri, 
      body: jsonEncode(control),
      headers:{
        'Content-Type': 'application/json'
      }
    );
    await cargaControl();
    print(resp.statusCode);
  
    } catch (e) {
      await DBProvider.db.nuevocontrol(control);
    }
    return dato1;
  }


    cargaControl() async {
      List<Control> control = [];
      control= await DBProvider.db.getTodosLosControl();
      if(control.length!=0){
         for (var i = 0; i < control.length; i++) {
         try {
            final uri = Uri.parse('https://apigob.herokuapp.com/api/control');
            final resp = await http.post(uri, 
            body: jsonEncode(control[i]),
            headers:{
            'Content-Type': 'application/json'
            }
            ); 
         } catch (e) {
           print(e);
         }
         }
         await DBProvider.db.dtrucneAllScan();
       }
      
    }


    datosbase( ) async {  
    isLoading = true;
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


   Future<String?>uploadImage(String? path) async {

   Usuario dato1 = Usuario();
   print('loadCartUser');
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String? kitJson = prefs.getString("content");
    final String? userStr = prefs.getString('content');
    print('--------------------------');
    print('--------------------------');

    if (userStr != null) {
      print('entro');
      Map<String, dynamic> userMap = jsonDecode(userStr);
      dato1=Usuario.fromJson(userMap);
    }

    this.selectedProduct.img = path;
    this.newPictureFile = File.fromUri(Uri(path: path));
    if( this.newPictureFile == null) return null;
    this.isSaving= true;
     notifyListeners();
     final url = Uri.parse('https://apigob.herokuapp.com/api/uploads/usuarios/${dato1.id}');
     final imageUploadRequest = http.MultipartRequest('PUT',url);
     final file= await http.MultipartFile.fromPath('archivo', newPictureFile!.path);
     imageUploadRequest.files.add(file);
     final streamResponse= await imageUploadRequest.send();
     final resp = await http.Response.fromStream(streamResponse);
    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salio mal');
      print(resp.body);
      return null;
    }
    notifyListeners();
    this.newPictureFile=null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }

    void updateSelectedProductImage( String? path){
    this.selectedProduct.img = path;
    this.newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
    }
  }

  
  // Future saveOrCreateProduct( Product product) async {
  //   isSaving = true;
  //   notifyListeners();

  //   if ( product.id == null){
  //     await this.createProduct(product);
  //   }else{
  //     await this.updateProduct(product); 
  //   }
  //   isSaving= false;
  //   notifyListeners();
  // }

  // Future<String> updateProduct(Product product ) async{
  //   final url = Uri.https( _baseUrl, 'Products/${product.id}.json');
  //   final resp = await http.put(url, body: product.toJson()  );
  //   final decodedData= resp.body;
  //    final index= this.products.indexWhere((element)=> element.id == product.id);
  //    this.products[index]= product;
  //    return product.id!;
  // }

  //  Future<String> createProduct( Usuario product ) async{
  //   final url = Uri.https( _baseUrl, 'Usuario.json');
  //   final resp = await http.post(url, body: product.toJson());
  //   final decodedData= json.decode(resp.body);
  //   //product.id= decodedData['name'];
  //   // this.products.add(product);
  //   print('jjjyjy');
  //   print(decodedData);
  //   print('jjtjtjjtjtj');
  //   return product.email!;
  // }

  // void updateSelectedProductImage( String path){
    
  //   this.selectedProduct.picture = path;
  //   this.newPictureFile = File.fromUri(Uri(path: path));

  //   notifyListeners();
  // }

  // Future<String?>uploadImage() async {
  //   if( this.newPictureFile == null) return null;

  //   this.isSaving= true;
  //    notifyListeners();
  //    final url = Uri.parse('https://api.cloudinary.com/v1_1/dve1nfb9j/image/upload?upload_preset=yqeniftu');
  //    final imageUploadRequest = http.MultipartRequest('POST',url);
  //    final file= await http.MultipartFile.fromPath('file', newPictureFile!.path);
  //    imageUploadRequest.files.add(file);
  //    final streamResponse= await imageUploadRequest.send();
  //    final resp = await http.Response.fromStream(streamResponse);
  //   if(resp.statusCode != 200 && resp.statusCode != 201){
  //     print('Algo salio mal');
  //     print(resp.body);
  //     return null;
  //   }
  //   this.newPictureFile=null;
  //   final decodedData = json.decode(resp.body);
  //   return decodedData['secure_url'];

  // }
