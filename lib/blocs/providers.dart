import 'package:chat/blocs/chat/chat_bloc.dart';
import 'package:chat/blocs/login/login_bloc.dart';
import 'package:chat/blocs/register/register_bloc.dart';
import 'package:chat/blocs/socket/socket_bloc.dart';
import 'package:chat/blocs/user/user_bloc.dart';
import 'package:flutter_bloc/src/bloc_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat/blocs/auth/authentication_bloc.dart';

List<BlocProviderSingleChildWidget> providers() {
  return [
    BlocProvider(
      create: (context) => AuthenticationBloc()
        ..add(AuthenticationStatusChanged(AuthenticationStatus.authenticated)),
    ),
    BlocProvider(create: (context) => LoginBloc()),
    BlocProvider(create: (context) => RegisterBloc()),
    BlocProvider(create: (context) => SocketBloc()),
    BlocProvider(create: (context) => ChatBloc()),
    BlocProvider(create: (context) => UserBloc(context.bloc<AuthenticationBloc>())),
  ];
}
