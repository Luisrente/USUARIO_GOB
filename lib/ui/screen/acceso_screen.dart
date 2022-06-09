import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gob_cordoba/models/control.dart';
import 'package:gob_cordoba/models/user.dart';
import 'package:gob_cordoba/services/carnet_services.dart';
import 'package:gob_cordoba/ui/widgets/cart_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccesoScreen extends StatelessWidget {
   
  const AccesoScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final carnetservice= Provider.of<CarnetService>(context);
    return Scaffold(
      body: Column(
        children: [
          CardWidget(dato: carnetservice.usualiorSelect),
             Padding(
               padding: const EdgeInsets.symmetric( vertical: 15 , horizontal: 35),
               child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                    icon: const  Icon(Icons.close),
                                    style: ElevatedButton. styleFrom(
                                    primary: Colors.red),
                                    // onPressed: () {
                                    //  // widget.check!.terms = true;
                                    //   Navigator.pop(context);
                                    // },
                                    onPressed: () => Navigator.of(context).pop(),
                                    label: const Text('Cancelar', style: TextStyle(fontSize: 15))
                                ),
                                SizedBox(width: 10),
                                ElevatedButton.icon(
                                    icon: const Icon(Icons.check),
                                    style: ElevatedButton. styleFrom(
                                    primary: Colors.green),
                                    onPressed: ()  async {
                                       Usuario dato1 = Usuario();
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
                                       DateTime now = new DateTime.now();
                                      Control con = Control(
                                           documentoAdmin:dato1.documento,
                                           nombreAdmin:dato1.nombre1,
                                           apellidoAdmin:dato1.apellido1,
                                           documentoUser:carnetservice.usualiorSelect.documento,
                                           nombreUser: carnetservice.usualiorSelect.nombre1,
                                           apellidoUser: carnetservice.usualiorSelect.apellido1,
                                           cargoUser: carnetservice.usualiorSelect.cargo,
                                           dependenciaUser: carnetservice.usualiorSelect.dependencia,
                                           hora:"${now}",
                                      );
                                       await carnetservice.loadControlAdmin(con);
                                       print('jfjfjfjfjjfjfjfjrururururururur');
                                      Navigator.pop(context);
                                    },
                                    label: const Text('Aceptar ', style: TextStyle(fontSize: 15))
                                ),
                              ],
                            ),
             )

        ],
      )
    );
  }
}