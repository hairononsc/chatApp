import 'package:chatapp/helpers/mostrar_alerta.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(titulo: 'Registro'),
                  _Form(),
                  Labels(
                    route: 'login',
                    titulo: 'Ingresa ahora',
                    subTitulo: '¿Ya tienes una cuenta?',
                  ),
                  Text('Terminos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: true,
            // keyboardType: TextInputType.pa,
            textController: passwordCtrl,
          ),
          BotonAzul(
              text: 'Registrar',
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final loginOk = await authService.register(
                          nameCtrl.text.trim(),
                          emailCtrl.text.trim(),
                          passwordCtrl.text.trim());

                      if (loginOk == true) {
                       
                        Navigator.pushReplacementNamed(context, 'users');
                        // TODO: Conectar a socket server

                      } else {
                        // Mostrar alerta
                        mostrarAlerta(context, 'Login incorrecto',
                            '$loginOk');
                      }
                    })
        ],
      ),
    );
  }
}
