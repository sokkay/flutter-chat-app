import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/pages/usuarios_page.dart';

final Map<String, WidgetBuilder> appRotes = {
  'usuarios': (BuildContext context) => UsuariosPage(),
  'chat': (BuildContext context) => ChatPage(),
  'login': (BuildContext context) => LoginPage(),
  'register': (BuildContext context) => RegisterPage(),
  'loading': (BuildContext context) => LoadingPage(),
};

Route<dynamic> appRoutes(RouteSettings settings) {
  switch (settings.name) {
    case usuariosPage:
      return MaterialPageRoute(
        builder: (BuildContext context) => UsuariosPage(),
        settings: RouteSettings(name: settings.name),
      );
    case chatPage:
      return MaterialPageRoute(
        builder: (BuildContext context) => ChatPage(),
        settings: RouteSettings(name: settings.name),
      );
    case loginPage:
      return MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
        settings: RouteSettings(name: settings.name),
      );
    case registerPage:
      return MaterialPageRoute(
        builder: (BuildContext context) => RegisterPage(),
        settings: RouteSettings(name: settings.name),
      );
    case loadingPage:
      return MaterialPageRoute(
        builder: (BuildContext context) => LoadingPage(),
        settings: RouteSettings(name: settings.name),
      );
    case profilePage:
      return MaterialPageRoute(
        builder: (BuildContext context) => ProfilePage(),
        settings: RouteSettings(name: settings.name),
      );
    default:
      return MaterialPageRoute(
        builder: (BuildContext context) => LoadingPage(),
        settings: RouteSettings(name: settings.name),
      );
  }
}
