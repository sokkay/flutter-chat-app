import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:chat/pages/usuarios_page.dart';

final Map<String, WidgetBuilder> appRotes = {
  'usuarios': (BuildContext context) => UsuariosPage(),
  'chat': (BuildContext context) => ChatPage(),
  'login': (BuildContext context) => LoginPage(),
  'register': (BuildContext context) => RegisterPage(),
  'loading': (BuildContext context) => LoadingPage(),
};
