import 'package:chat/blocs/providers.dart';
import 'package:chat/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:chat/routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() =>
    runApp(MultiBlocProvider(providers: providers(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRoutes,
      initialRoute: loadingPage,
    );
  }
}
