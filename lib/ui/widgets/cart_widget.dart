import 'package:flutter/material.dart';
import 'package:gob_cordoba/data/encryption_service.dart';
import 'package:gob_cordoba/services/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../data/AES.dart';
import '../../models/models.dart';

class CardWidget extends StatelessWidget {

  final Usuario dato;
  const CardWidget({Key? key,  required this.dato}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carnetservice= Provider.of<CarnetService>(context);
    final EncryptionService encryptionService= new EncryptionService();
    String documentId = dato.document!;
    print(documentId);
    double height = MediaQuery.of(context).size.height* 0.70;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 30),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        decoration: _cardBordes(),
        child: Column(
          // alignment: Alignment.bottomCenter,
          children: [
            _Encabezado( usuario: dato),
            Expanded(child: Column(
              children: [
                _CodigoQR(documento: documentId),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
                        child: Row(
                          children: const [
                              Text(
                                  'Secretaria: ',
                                  style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                                  ),
                             Text(
                             'Secretaria de educacion',
                              style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 50, 49, 49)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                       ),      
                          ]
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
                        child: Row(
                          children: const [
                          Text(
                                  'Contrado: ',
                                  style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                                  ),
                          Text(
                             'Prestacion de Servicios',
                              style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 50, 49, 49)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                       ),
                          ]
                        ),
                      ),
                      const   SizedBox(height: 20) ,
                      const Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                                 'Este carnet es un documento intitucional el cual te agredita como trabajador de la gobernacion de cordoba su comercializacion es un delito',
                                  style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 50, 49, 49)),
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                       ),
                          ),
                        )
                      
                    ],
                  ),

                
                )

              ],
            )),
             Cargo()
          ]

        )
      ),
    );
  }

  BoxDecoration _cardBordes() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,3),
        blurRadius: 10
      )
    ]
  );

}

class _Encabezado extends StatelessWidget {
  
  final Usuario usuario;
  
  const _Encabezado({
    Key? key,  required this.usuario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:30, bottom: 30),
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
             usuario.name! ,
              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
           const SizedBox(height: 5 ),
              Text(
                  'CC: '+ usuario.document! ,
               style: TextStyle(fontSize: 18, color: Colors.black),
               maxLines: 1,
               overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      )
    );
  }
}

class _CodigoQR extends StatelessWidget {
  final documento;
  
  const _CodigoQR({
    Key? key, this.documento,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tamano = MediaQuery.of(context).size;
    final EncryptionService encryptionService= new EncryptionService();

    return Container(
      height: tamano.height*0.25 ,
      width: tamano.width*0.5,
      child: QrImage(data: encryptionService.encryptData(documento))
    );
  }
}

class Cargo extends StatelessWidget {
  const Cargo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height:60,
      decoration: _buildBoxDecoration(),
      child: const Center(
        child: Text(
          'SECRETARIO',
          style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      )
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)  )


  );
}