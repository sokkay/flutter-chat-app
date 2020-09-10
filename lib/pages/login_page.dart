import 'package:chat/blocs/auth/authentication_bloc.dart';
import 'package:chat/blocs/login/login_bloc.dart';
import 'package:chat/helpers/error_dialog.dart';
import 'package:chat/helpers/loading_dialog.dart';
import 'package:chat/routes/routes_constants.dart';
import 'package:chat/widgets/button_blue.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/login/labels.dart';
import 'package:chat/widgets/login/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

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
  void initState() {
    super.initState();
    _addListeners();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionInProgress) {
          showLoadingDialog(context);
        }
        if (state.status == FormzStatus.submissionSuccess) {
          Navigator.pop(context);
          context.bloc<AuthenticationBloc>().add(
              AuthenticationStatusChanged(AuthenticationStatus.authenticated));
        }
        if (state.status == FormzStatus.submissionFailure) {
          Navigator.pop(context);
          showErrorDialog(
            context,
            'Un error ha ocurrido',
            'Contraseña o email inválido',
          );
        }
      },
      child: Container(
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
              onPressed: () => _handleLogin(),
              text: 'Ingrese',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    context.bloc<LoginBloc>().add(LoginSubmitted());
  }

  void _addListeners() {
    this.emailCtrl.addListener(() => context
        .bloc<LoginBloc>()
        .add(LoginEmailChanged(this.emailCtrl.text.trim())));
    this.passwordCtrl.addListener(() => context
        .bloc<LoginBloc>()
        .add(LoginPasswordChanged(this.passwordCtrl.text.trim())));
  }
}
