import 'package:chat/blocs/auth/authentication_bloc.dart';
import 'package:chat/blocs/chat/chat_bloc.dart';
import 'package:chat/blocs/socket/socket_bloc.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/routes/routes_constants.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarioService = new UsuariosService();

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthenticationBloc>().state.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name,
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {
            context
                .bloc<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested());
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: BlocBuilder<SocketBloc, SocketState>(
              buildWhen: (previous, current) =>
                  previous.serverStatus != current.serverStatus,
              builder: (context, state) {
                if (state.serverStatus == ServerStatus.Online) {
                  return Icon(Icons.check_circle, color: Colors.blue[400]);
                } else {
                  return Icon(Icons.offline_bolt, color: Colors.red[400]);
                }
              },
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () {
          _refreshController.loadComplete();
        },
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        child: _listViewUsers(),
      ),
    );
  }

  Widget _listViewUsers() {
    final user = context.bloc<AuthenticationBloc>().state.user;
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(user.friends[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: user.friends.length,
    );
  }

  Widget _userListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.name),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red[400],
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        context.bloc<ChatBloc>().add(ChatGetAll(usuario));
        Navigator.pushNamed(context, chatPage).then((value) =>
            context.bloc<SocketBloc>().state.socket.off('mensaje-personal'));
      },
    );
  }
}
