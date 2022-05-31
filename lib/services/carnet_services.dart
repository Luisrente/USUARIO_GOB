import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gob_cordoba/models/model/loginResponse.dart';
// import 'package:gob_cordoba/models/models.dart';
import 'package:gob_cordoba/models/user.dart';
import 'package:gob_cordoba/provider/db_provider.dart';
import 'package:gob_cordoba/provider/scan_list_provider.dart';
import 'package:gob_cordoba/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CarnetService extends ChangeNotifier{

  final String _baseUrl = 'flutter-73f8f-default-rtdb.firebaseio.com';
  final storage = new FlutterSecureStorage();
  List<Usuario> usuarios = [];
  late Usuario usuario;

   ScanListProvider base= new ScanListProvider();

  File? newPictureFile;
  bool isLoading = false;
  bool isSaving = false;

  CarnetService(){
    this.loadCartUser();

  }
 Future<String>readData()async{
  return  await storage.read(key:'data') ?? '';
  }
  // TODO: 


   Future <Usuario> loadCartUser() async {
    Usuario dato1 = Usuario();

   SharedPreferences prefs = await SharedPreferences.getInstance();
   String? kitJson = prefs.getString("content");
    final String? userStr = prefs.getString('content');
    print('--------------------------');
    print(userStr);
    print('--------------------------');
    if (userStr != null) {
      print('entro');
      Map<String, dynamic> userMap = jsonDecode(userStr);
      return Usuario.fromJson(userMap);
    }
      return dato1;
  }

  Future <Usuario> loadCarstAdmin( String id) async {
    isLoading = true;
    notifyListeners();
    Usuario dato1 = Usuario();

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
      return usuario;
    } else {
      final Usuario scans= await DBProvider.db.getScanById(id);
     if(scans.apellido1==null){
       print('null');
     }else{
       return scans;
     } 
    }
    } catch (e) {
      NotificationsService.showSnackbar("Comunicarse con el admin ");
    }
    return dato1;
    
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
    print('paso');
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      final  usuarioi = loginResponse.usuario;
      print(usuarioi);

      for (var i = 0; i < usuarios.length-1 ; i++) { 
      final s =  await DBProvider.db.nuevoScan(usuarios[i]);
    }
    } else {
    //   final ScanModel scans= await DBProvider.db.getScanById(1);
    //  if(scans.tipo==null){
    //    print('null');
    //  }else{
    //    return scans;
    //  } 
    }
    } catch (e) {
      NotificationsService.showSnackbar("Comunicarse con el admin ");
    }

    // for (var i = 0; i < usuarios.length-1 ; i++) { 
    //   final s =  await DBProvider.db.nuevoScan(usuarios[i]);
    // }
    // print('con exito');
    // isLoading= false;
    // notifyListeners();
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




}