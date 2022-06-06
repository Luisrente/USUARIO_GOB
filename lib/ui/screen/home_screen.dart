import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gob_cordoba/provider/product_forma_provicer.dart';
import 'package:gob_cordoba/services/services.dart';
import 'package:gob_cordoba/ui/screen/screens.dart';
import 'package:gob_cordoba/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);



    void displayDialog (BuildContext context , String model){
    final carnetservice= Provider.of<CarnetService>(context,listen:false);
    showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        elevation: 5,
                         title:  Center(
                          child:  Text( 'Verificar',
                              style: TextStyle(color: Colors.black)),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(10)),
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30)  ,
                                child: ProductImage(url: model),
                              )
                            ]
                            ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                    icon: const  Icon(Icons.close),
                                    style: ElevatedButton. styleFrom(
                                    primary: Colors.red),
                                    onPressed: () {
                                     // widget.check!.terms = true;
                                      Navigator.pop(context);
                                    },
                                    label: const Text('Cancelar', style: TextStyle(fontSize: 15))
                                ),
                                SizedBox(width: 10),
                                ElevatedButton.icon(
                                    icon: const Icon(Icons.check),
                                    style: ElevatedButton. styleFrom(
                                    primary: Colors.green),
                                    onPressed: () {
                                     // widget.check!.terms = true;
                                     if ((carnetservice.uploadImage(model))== null){
                                        NotificationsService.showSnackbar('No se guardo');
                                     }
                                     print('entro aqui');
                                     Navigator.pop(context);
                                    },
                                    label: const Text('Aceptar ', style: TextStyle(fontSize: 15))
                                ),
                              ],
                            ),
                          )
                        ]);
                  });
  }
  
  @override
  Widget build(BuildContext context) {

  final tam = MediaQuery.of(context).size.height * 0.09;
  final carnetservice= Provider.of<CarnetService>(context);
  final dato= carnetservice.loadCartUser();
  // print(dato.nombre1);
  final authService= Provider.of<AuthService>(context , listen: false);
  final storage = new FlutterSecureStorage();
  final  t= authService.readToken();


  if(carnetservice.isLoading) return const LoadingScreen();
    return  Scaffold(
       appBar: 
      AppBar(
         actions:[
             Row(
               children: [
                 IconButton(
                 icon: const  Icon( Icons.login_outlined , color: Colors.black),
                 onPressed: () async{
                 final pref = await SharedPreferences.getInstance();
                 await pref.clear();
                 await authService.logunt();
                 Navigator.pushReplacementNamed(context, 'login');
                }
        ),
               ],
             ),
          
      ],
      title: Center(
      child: SizedBox(
        height: kToolbarHeight,
        child: Image.asset('assets/logo.png'),
      ),
    ),
      toolbarHeight: kToolbarHeight,
        leading: IconButton(
          icon: const  Icon( Icons.menu , color: Colors.black),
          onPressed: () async {
                       final picker = new ImagePicker();
                       final PickedFile? pickedFile = await picker.getImage(
                         source: ImageSource.gallery,
                         imageQuality: 100
                       );
                       if( pickedFile == null){
                         print('No selecciono nada');
                         return;
                       }
                       displayDialog(context,pickedFile.path);
                      //  ShowImg(model: pickedFile.path);
                       print( 'Tenemos imagen ${pickedFile.path}');
                      //  carnetservice.uploadImage(pickedFile.path);
                     },
        ), 
        backgroundColor: Colors.white,
        elevation: 1
      ),
      body: FutureBuilder<Usuario>(
        future: carnetservice.loadCartUser(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
          return CardWidget(dato: snapshot.data!);
          }else{
            return const Center(
              child:  CircularProgressIndicator(
                color: Colors.black12
              ),
            );
          }
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child:  const Icon(Icons.qr_code_2_outlined),
        onPressed: ()  { 
        try {
          
        } catch (e) {
          print(e);
          NotificationsService.showSnackbar('$e');
        }
      },
      )
      // bottomNavigationBar: const CustomNavigatonBar (),
    );
  }

  void ConfirmarImgen(BuildContext context, PickedFile pickedFile) => displayDialog(context, pickedFile.path);
}

class ShowImg extends StatelessWidget {

  final String model;
  const ShowImg({
    Key? key,  required  this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final carnetservice= Provider.of<CarnetService>(context);
    return  AlertDialog(
                        elevation: 5,
                         title:  Center(
                          child:  Text( 'Verificar',
                              style: TextStyle(color: Colors.black)),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(10)),
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:[
                              ProductImage(url: model)
                            ]
                            ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                    icon: const  Icon(Icons.close),
                                    style: ElevatedButton. styleFrom(
                                    primary: Colors.red),
                                    onPressed: () {
                                     // widget.check!.terms = true;
                                      Navigator.pop(context);
                                    },
                                    label: const Text('Cancelar', style: TextStyle(fontSize: 15))
                                ),
                                SizedBox(width: 10),
                                ElevatedButton.icon(
                                    icon: const Icon(Icons.check),
                                    style: ElevatedButton. styleFrom(
                                    primary: Colors.green),
                                    onPressed: () {
                                     // widget.check!.terms = true;
                                     if ((carnetservice.uploadImage(model))== null){
                                        NotificationsService.showSnackbar('No se guardo');
                                     }
                                     print('entro aqui');
                                     Navigator.pop(context);
                                    },
                                    label: const Text('Aceptar ', style: TextStyle(fontSize: 15))
                                ),
                              ],
                            ),
                          )
                        ]
                        );

  }
}