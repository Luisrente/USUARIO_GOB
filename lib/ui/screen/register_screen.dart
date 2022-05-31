
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gob_cordoba/models/models.dart';
import 'package:gob_cordoba/services/auth_service.dart';
import 'package:gob_cordoba/services/carnet_services.dart';
import 'package:gob_cordoba/services/notications_service.dart';
import 'package:gob_cordoba/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../provider/login_form_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      final tam = MediaQuery.of(context).size.height * 0.17;
    return  Scaffold(
      appBar: 
      AppBar(
         actions:[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/logo.png',
                fit: BoxFit.cover, alignment: Alignment.center),
          ),
          SizedBox(width: tam)
      ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children:  [
            const SizedBox(height: 80),
            CardContainer(
              child:  Column(
                children: [
                   const SizedBox( height: 10),
                   Text('Password',style: Theme.of(context).textTheme.headline4),
                   const SizedBox( height: 30),
                   ChangeNotifierProvider(
                     create: (_) => LoginFormProvider( ),
                     child: _Login_Form()
                   ),
                ]
              )
            ),
            const SizedBox(height:50),
             TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Color.fromARGB(255, 6, 151, 235)),
                shape: MaterialStateProperty.all( const StadiumBorder())
              ),
              child: const Text('¿Ya tengo una cuenta? ', style: TextStyle( fontSize: 18, color: Colors.black87)),
            ),
            const SizedBox(height:50),
          ]
        )
      ),
    );
  }
}

class _Login_Form extends StatelessWidget {

  const _Login_Form({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final loginForm= Provider.of<LoginFormProvider>(context);
     
    final storage = new FlutterSecureStorage();

    return Container(
      child:  Form(
        key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children:[
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hinText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: (value) => loginForm.password= value,
              validator: (value) {
                return( value != null && value.length >= 6)
                  ? null
                  : 'La constraseña debede ser de 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hinText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: (value) => loginForm.name= value,
              validator: (value) {
                return( value != null && value.length >= 6 && loginForm.password==value)
                  ? null
                  : 'La constraseña debede ser iguales';
              },
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Color.fromARGB(255, 2, 116, 208),
              child: Container(
                padding: const EdgeInsets.symmetric( horizontal: 80, vertical: 15 ),
                child:  Text(
                   loginForm.isLoading 
                   ? 'Espere...'
                   : 'Registrar', 
                style:  const TextStyle(color: Colors.white),
                )
              ),
              onPressed:  loginForm.isLoading ? null : () async {
                FocusScope.of(context).unfocus();
             final authService= Provider.of<AuthService>(context, listen:false);
             final carnetService= Provider.of<CarnetService>(context, listen: false);

                if(!loginForm.isValidForm()) return ;
                loginForm.isLoading= true;
                await Future.delayed( const Duration(seconds: 2));
                String id= await  authService.readId();
               final String errorMessag= await authService.password(loginForm.password,id);
                if(errorMessag == '1'){
                Navigator.pushReplacementNamed(context, 'check');
                }else{
                  loginForm.isLoading= false;
                }
            }

              
            )       ]
        )
      )
      );
  }
}