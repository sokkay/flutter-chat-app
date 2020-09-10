import 'package:chat/blocs/auth/authentication_bloc.dart';
import 'package:chat/blocs/socket/socket_bloc.dart';
import 'package:chat/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            context.bloc<SocketBloc>().add(SocketConnect());
            Navigator.pushReplacementNamed(context, usuariosPage);
          } else if (state.status == AuthenticationStatus.unauthenticated) {
            context.bloc<SocketBloc>().add(SocketDisconnect());
            Navigator.pushReplacementNamed(context, loginPage);
          }
        },
        child: Center(
          child: Text('Espere...'),
        ),
      ),
    );
  }
}
