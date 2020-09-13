import 'package:chat/pages/main_page/widgets/background.dart';
import 'package:chat/pages/main_page/widgets/chats_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/blocs/auth/authentication_bloc.dart';
import 'package:chat/blocs/chat/chat_bloc.dart';
import 'package:chat/blocs/socket/socket_bloc.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/routes/routes_constants.dart';

class ChatsPage extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: false,
      onRefresh: () {},
      physics: NeverScrollableScrollPhysics(),
      header: WaterDropHeader(
        complete: Icon(Icons.check, color: Colors.blue[400]),
        waterDropColor: Colors.blue[400],
      ),
      child: Stack(
        children: [
          // Fondo
          Positioned(
            top: 0,
            left: 0,
            child: ChatsBackground(),
          ),
          //------------------------
          //------------------------
          // Appbar
          Positioned(
            top: 0,
            left: 0,
            child: ChatsAppBar(),
          ),
          //-----------------------
          // -----------------------
          // UsersList
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * 0.60,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30),
                  topRight: const Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: Offset(0, -2),
                    blurRadius: 2,
                  )
                ],
              ),
              child: _listViewUsers(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listViewUsers(BuildContext context) {
    final user = context.bloc<AuthenticationBloc>().state.user;
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(user.friends[i], context),
      separatorBuilder: (_, i) => Divider(),
      itemCount: user.friends.length,
    );
  }

  Widget _userListTile(Usuario user, BuildContext context) {
    Widget circleAvatar;
    if (user.avatarPreset == null) {
      circleAvatar = CircleAvatar(
        child: Text(user.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      );
    } else {
      circleAvatar = CircleAvatar(
        backgroundImage: AssetImage(user.avatarPreset),
      );
    }
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: circleAvatar,
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red[400],
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        context.bloc<ChatBloc>().add(ChatGetAll(user));
        Navigator.pushNamed(context, chatPage).then((value) =>
            context.bloc<SocketBloc>().state.socket.off('mensaje-personal'));
      },
    );
  }
}
