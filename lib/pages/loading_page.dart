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
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            context.bloc<SocketBloc>().add(SocketConnect());
            Navigator.pushNamedAndRemoveUntil(
                context, usuariosPage, ModalRoute.withName(loadingPage));
          } else if (state.status == AuthenticationStatus.unauthenticated) {
            context.bloc<SocketBloc>().add(SocketDisconnect());
            Navigator.pushNamedAndRemoveUntil(
                context, loginPage, ModalRoute.withName(loadingPage));
          }
        },
        child: Center(
          child: Text('Espere...'),
        ),
      ),
    );
  }
}
