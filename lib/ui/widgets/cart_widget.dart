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
    final carnetservice= Provider.of<CarnetService>(context,listen: false);
    final EncryptionService encryptionService= new EncryptionService();
    String documentId = dato.document!;
    print(documentId);
    double height = MediaQuery.of(context).size.height* 0.75;
    double padding = MediaQuery.of(context).size.width* 0.07;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: padding , vertical: 30),
      child: Container(
        margin: EdgeInsets.only(top: 30),
        height: height,
        width: double.infinity,
        decoration: _cardBordes(),  
      child: Stack (

        children: [
          Positioned(
            left: 0,
            child: Cargo()
          ),
           Positioned(
            top: 5,
            right: 1,
            bottom: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25)
              ),
              width:   MediaQuery.of(context).size.width* 0.69,
              height:  MediaQuery.of(context).size.height* 0.75,
              child: Column(
                children:[
                  Padding(
                    padding: const EdgeInsets.only(right:25,left:25,top: 30, bottom:20),
                    child: Image.asset('assets/logo.png',   
                    alignment: Alignment.center),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45),
                      child: Container(
                        width: 180,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment : CrossAxisAlignment.center,
                          children: [
                            _Foto(),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, bottom: 10 ),
                              child: Column(
                                children: [
                                  Text( 'Sara Rodriguez' , style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold)),
                    
                                  Text( 'Secretaria',style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                                ],
                              ),
                            ),
                            _CodigoQR(documento: 'rrrrr'),
                            Text( 'CC: 1193565389',style: TextStyle( fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black)),
                          ]

                        )
                      ),
                    ),
                  ),

                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: const Text('www.cordoba.gov.co', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(115, 9, 46, 83)))),
                  )
                ],
            
              )
            )
          ),
              Positioned(
                right: 0,
                bottom: 30,
               child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:10, horizontal:10),
                      child: Container(
                        color: Colors.blue,
                        height: 5,
                        width: MediaQuery.of(context).size.width* 0.65, 
                      ),
                    ),
             ),
        ]


      ),
      
      
      
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
    return Padding(
      padding: const EdgeInsets.only(left: 7),
      child: Container(
        height: tamano.height*0.2 ,
        width: tamano.width*0.5,
        child: QrImage(data: encryptionService.encryptData(documento))
      ),
    );
  }
}
class _Foto extends StatelessWidget {
  
  const _Foto({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tamano = MediaQuery.of(context).size;
    String url= 'https://thumbs.dreamstime.com/z/retrato-de-hombre-mirando-la-c%C3%A1mara-sobre-el-fondo-blanco-158750254.jpg';
    final  url1= null;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Container(
          height: tamano.height*0.2 ,
          width: tamano.width*0.5,
          child: url == null
        ? Image(image: const AssetImage('assets/persona.jpeg'),
          fit: BoxFit.cover
        )
        : FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(url),
          fit: BoxFit.cover
        )
        ),
      ),
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
      height: MediaQuery.of(context).size.height* 0.75,
      width: MediaQuery.of(context).size.width* 0.16,
      decoration: _buildBoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Align(
          alignment : Alignment.topCenter,
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              'SEC. TRANSPORTE ',
              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      )
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),  topLeft: Radius.circular(25)  )


  );
}