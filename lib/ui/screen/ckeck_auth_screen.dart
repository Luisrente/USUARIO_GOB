import 'package:flutter/material.dart';
import 'package:gob_cordoba/models/models.dart';
import 'package:gob_cordoba/services/services.dart';
import 'package:gob_cordoba/ui/screen/screens.dart';
import 'package:provider/provider.dart';

import 'package:gob_cordoba/shared_prefe/preferencias_user.dart';
class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

        final prefe= Provider.of<UserPrefe>(context,listen:false);

  // final prefe= UserPrefe();
  Usuario? dato = Usuario();
  final authService= Provider.of<AuthService>(context, listen: false);
    
    return  Scaffold(
      body: Center(
         child: FutureBuilder<Usuario>(
           future: prefe.userget(),
           builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot){
             if(!snapshot.hasData)
              return  Center(
                     child: SizedBox(
                          height: kToolbarHeight,
                          child: Image.asset('assets/logo.png'),
                           ),
                            );
               dato=snapshot.data;
             if (snapshot.hasData){
            //  if ( (dato.rol!) == 'ADMIN_ROLE'){
              Future.microtask((){
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: ( _ , __ , ___) => const LoginScreen(),
                  transitionDuration: const Duration( seconds: 0)
                ));
                //Navigator.of(context).pushReplacementNamed('home');
              });
             }
            //   if ( dato.rol == 'USER_ROLE'){
            //   Future.microtask((){
            //     Navigator.pushReplacement(context, PageRouteBuilder(
            //       pageBuilder: ( _ , __ , ___) => const HomeScreen(),
            //       transitionDuration: const Duration( seconds: 0)
            //     ));
            //     //Navigator.of(context).pushReplacementNamed('home');
            //   });
            //  }
            //   if ( dato.rol == ''){
            //   Future.microtask((){
            //     Navigator.pushReplacement(context, PageRouteBuilder(
            //       pageBuilder: ( _ , __ , ___) => const LoginScreen(),
            //       transitionDuration: const Duration( seconds: 0)
            //     ));
            //     //Navigator.of(context).pushReplacementNamed('home');
            //   });
            //  }
             
              return Container();
           },
           ),
      ),
    );
  }
}