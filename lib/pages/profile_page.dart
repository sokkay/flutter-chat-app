import 'package:chat/blocs/auth/authentication_bloc.dart';
import 'package:chat/blocs/user/user_bloc.dart';
import 'package:chat/helpers/error_dialog.dart';
import 'package:chat/helpers/loading_dialog.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.userStatus == UserStatus.loading) {
          showLoadingDialog(context);
        }
        if (state.userStatus == UserStatus.complete) {
          Navigator.pop(context);
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Usuario actualizado'),
          ));
        }
        if (state.userStatus == UserStatus.error) {
          Navigator.pop(context);
          showErrorDialog(context, 'Ha Ocurrido un error', state.errorMessage);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          buildWhen: (previuos, current) => previuos.user != current.user,
          builder: (context, state) {
            final user = state.user;
            return _buildBody(size, user, context);
          },
        ),
      ),
    );
  }

  Widget _buildBody(Size size, Usuario user, BuildContext context) {
    return Stack(
      children: [
        _fondo(size),
        CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: size.height * 0.3,
              iconTheme: IconThemeData(color: Colors.black54),
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Hero(
                          tag: "user avatar",
                          child: CircleAvatar(
                            backgroundImage: AssetImage(user.avatarPreset),
                            radius: 32,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 7),
                        SizedBox(
                          width: size.width * 0.5,
                          child: Text(
                            user.description ?? 'Descripcion',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 7),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Online',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildOptions(size, user, context)
          ],
        ),
      ],
    );
  }

  SliverList _buildOptions(Size size, Usuario user, BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height * 0.68),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perfil',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  _cardOption(
                    title: 'Nombre',
                    subtitle: user.name,
                    onTap: () => openDialog(
                      context: context,
                      title: 'Escribe tu nombre',
                      content: user.name,
                      saveAction: (text) {
                        if (user.name != text) {
                          user.name = text;
                          context.bloc<UserBloc>().add(UserUpdateInfo(user));
                        }
                      },
                    ),
                  ),
                  _cardOption(
                    title: 'Descripción',
                    subtitle: user.description,
                    onTap: () => openDialog(
                      context: context,
                      title: 'Di lo que piensas',
                      content: user.description,
                      saveAction: (text) {
                        if (user.description != text) {
                          user.description = text;
                          context.bloc<UserBloc>().add(UserUpdateInfo(user));
                        }
                      },
                    ),
                  ),
                  _cardOption(
                    title: 'Email',
                    subtitle: user.email,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card _cardOption({String title, String subtitle, VoidCallback onTap}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: onTap != null ? Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }

  Container _fondo(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey[50],
            Colors.purple[50],
            Colors.grey[50],
          ],
        ),
      ),
    );
  }

  void openDialog({
    BuildContext context,
    String title,
    String content,
    Function(String value) saveAction,
  }) async {
    final inputCtrl = new TextEditingController();
    inputCtrl.text = content;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(title),
        actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        content: TextField(
          controller: inputCtrl,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey[200],
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
        ),
        actions: [
          MaterialButton(
            minWidth: double.maxFinite,
            color: Colors.redAccent,
            child:
                Text('Guardar', style: TextStyle(fontWeight: FontWeight.w900)),
            shape: StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 14),
            onPressed: () {
              saveAction(inputCtrl.text.trim());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
