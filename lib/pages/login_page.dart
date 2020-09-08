import 'package:chat/helpers/error_dialog.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/button_blue.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/login/labels.dart';
import 'package:chat/widgets/login/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
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
                Logo(
                  title: 'Messenger',
                ),
                _Form(),
                Labels(
                  route: 'register',
                  askTitle: '¿No tienes cuenta?',
                  title: 'Crea una ahora!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
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
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: 'Contraseña',
            isPassword: true,
            textController: passwordCtrl,
          ),
          ButtonBlue(
            onPressed: authService.autenticando
                ? null
                : () => _handleLogin(authService),
            text: 'Ingrese',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void _handleLogin(AuthService authService) async {
    FocusScope.of(context).unfocus();
    final error = await authService.login(
      emailCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );
    if (error != null) {
      showErrorDialog(context, "Ha ocurrido un error", error);
    } else {
      Provider.of<SocketService>(context, listen: false).connect();
      Navigator.pushReplacementNamed(context, 'usuarios');
    }
  }
}
