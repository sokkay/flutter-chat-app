import 'package:chat/blocs/auth/authentication_bloc.dart';
import 'package:chat/blocs/register/register_bloc.dart';
import 'package:chat/helpers/body_height.dart';
import 'package:chat/helpers/error_dialog.dart';
import 'package:chat/helpers/loading_dialog.dart';
import 'package:chat/widgets/button_blue.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/login/labels.dart';
import 'package:chat/widgets/login/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: bodyHeightWithOutAppBar(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(title: 'Register'),
                  _Form(),
                  Labels(
                    route: 'login',
                    askTitle: '¿Ya tienes cuenta?',
                    title: 'Ingresa Ahora!',
                  ),
                ],
              ),
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void initState() {
    _addListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionInProgress) {
          showLoadingDialog(context);
        }
        if (state.status == FormzStatus.submissionFailure) {
          Navigator.pop(context);
          showErrorDialog(context, "Ha ocurrido un error", state.errorMessage);
        }
        if (state.status == FormzStatus.submissionSuccess) {
          Navigator.pop(context);
          context.bloc<AuthenticationBloc>().add(
              AuthenticationStatusChanged(AuthenticationStatus.authenticated));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          children: [
            CustomInput(
              icon: Icons.perm_identity,
              placeholder: 'Nombre',
              textController: nameCtrl,
            ),
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
              onPressed: () => _handleRegister(),
              text: 'Ingrese',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    FocusScope.of(context).unfocus();
    context.bloc<RegisterBloc>().add(RegisterSubmitted());
  }

  void _addListeners() {
    emailCtrl.addListener(() => context
        .bloc<RegisterBloc>()
        .add(RegisterEmailChanged(emailCtrl.text.trim())));
    passwordCtrl.addListener(() => context
        .bloc<RegisterBloc>()
        .add(RegisterPasswordChanged(passwordCtrl.text.trim())));
    nameCtrl.addListener(() => context
        .bloc<RegisterBloc>()
        .add(RegisterNameChanged(nameCtrl.text.trim())));
  }
}
