import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gob_cordoba/models/models.dart';
import 'package:gob_cordoba/provider/db_provider.dart';
import 'package:gob_cordoba/provider/scan_list_provider.dart';
import 'package:gob_cordoba/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class CarnetService extends ChangeNotifier{

  final String _baseUrl = 'flutter-73f8f-default-rtdb.firebaseio.com';
  late Carnet? carnets ;
  final storage = new FlutterSecureStorage();
  List<ScanModel> scans = [];
  List<Usuario> usuarios = [];
   
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
   final firstname= await storage.read(key:'email') ?? '';
   final name= await storage.read(key:'name') ?? '';
   final document= await storage.read(key:'document') ?? '';
   final email1= await storage.read(key:'email1') ?? '';
   final password= await storage.read(key:'password') ?? '';

    if( name != '' ){
      print('Entro por primera vez');
      final  Usuario dato = Usuario(
                  document: document,
                  email: email1 ,
                  name: name,
                  password : password,
               );
        return dato;

    }else{
      try {
       final url11 = Uri.https( _baseUrl, 'Usuario.json');
       final resp2 = await http.put(url11);
       final resp3 = await http.put(url11);
       await Future.delayed( const Duration(seconds: 7));
    final url = Uri.https( _baseUrl, 'Usuario.json');
    final resp = await http.get(url);    
    final Map<String, dynamic> productsMap= json.decode(resp.body);
    productsMap.forEach(( key , value){
      final tempProduct = Usuario.fromMap(value);
      this.usuarios.add(tempProduct);
    });
    print('-------------------correo--------------------');
      print(firstname);
    print('-------------------correo--------------------');

    for (var i = 0; i < usuarios.length-1 ; i++) { 
      String dato= usuarios[i].email!;
      print(dato);
      //print(dato);
      if(dato == firstname){
        print('Entro ddddddd');
        //print('$usuarios[i]');
        print(usuarios[i]);
        await storage.write(key: 'document', value: usuarios[i].document);
        await storage.write(key: 'email1', value: usuarios[i].email);
        await storage.write(key: 'name', value: usuarios[i].name);
        await storage.write(key: 'password', value: usuarios[i].password);
        return  usuarios[i];
      }
    }        
      } catch (e) {
       NotificationsService.showSnackbar('Error 404');
      }

    }
    return dato1;
  }

  Future <ScanModel> loadCarstAdmin( int documentId) async {
    isLoading = true;
    notifyListeners();
    
    final url = Uri.https( _baseUrl, 'Usuario.json');
    final resp = await http.get(url);
    final  productsMap= json.decode(resp.body);
    isLoading= false;
    notifyListeners();
    ScanModel scans1= ScanModel();
    try {
       await Future.delayed(const Duration(seconds: 4));
    } catch (e) {
    }
    if(isLoading==true)
    {
    }else{
     final ScanModel scans= await DBProvider.db.getScanById(1);
     if(scans.tipo==null){
       print('null');
     }else{
       return scans;
     }  
    }
    return scans1;
    // return null;    
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

   Future<String> createProduct( Usuario product ) async{
    final url = Uri.https( _baseUrl, 'Usuario.json');
    final resp = await http.post(url, body: product.toJson());
    final decodedData= json.decode(resp.body);
    //product.id= decodedData['name'];
    // this.products.add(product);
    print('jjjyjy');
    print(decodedData);
    print('jjtjtjjtjtj');
    return product.email!;

  }

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