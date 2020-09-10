import 'package:chat/blocs/auth/authentication_bloc.dart';
import 'package:chat/blocs/chat/chat_bloc.dart';
import 'package:chat/blocs/socket/socket_bloc.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textCtrl = new TextEditingController();
  final _focusNode = new FocusNode();
  bool isWritting = false;

  List<ChatMessage> _messagesWidget = [];

  @override
  void initState() {
    super.initState();
    context
        .bloc<SocketBloc>()
        .state
        .socket
        .on('mensaje-personal', _listenMessage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.chatStatus == ChatStatus.complete) {
          final history = state.messages.map(
            (e) => new ChatMessage(
              texto: e.message,
              uid: e.from,
              myUid: context.bloc<AuthenticationBloc>().state.user.uid,
            ),
          );
          _messagesWidget.insertAll(0, history);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: true,
            title: Column(
              children: [
                CircleAvatar(
                  child: Text(
                    state.userTo.name.substring(0, 2),
                    style: TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.blue[100],
                  maxRadius: 14,
                ),
                SizedBox(height: 3),
                Text(
                  state.userTo.name,
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                )
              ],
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (_, i) => _messagesWidget[i],
                    itemCount: _messagesWidget.length,
                    reverse: true,
                  ),
                ),
                Divider(height: 1),
                Container(
                  color: Colors.white,
                  child: _inputChat(),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    _messagesWidget.forEach((m) => m.animationController?.dispose());
    super.dispose();
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textCtrl,
                decoration: InputDecoration(
                  hintText: 'Enviar Mensaje',
                  border: InputBorder.none,
                ),
                focusNode: _focusNode,
                onSubmitted: _handleSubmit,
                onChanged: (value) => setState(
                  () => value.trim().length > 0
                      ? isWritting = true
                      : isWritting = false,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 4.0),
              child: FloatingActionButton(
                onPressed: isWritting
                    ? () => _handleSubmit(_textCtrl.text.trim())
                    : null,
                child: Icon(Icons.send, size: 18),
                elevation: 0,
                mini: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String text) {
    _focusNode.requestFocus();
    if (text.trim().length == 0) return;

    final chatBloc = context.bloc<ChatBloc>().state;
    final authBloc = context.bloc<AuthenticationBloc>().state;
    final socketBloc = context.bloc<SocketBloc>().state;

    _messagesWidget.insert(
      0,
      new ChatMessage(
        uid: authBloc.user.uid,
        texto: text,
        myUid: authBloc.user.uid,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 250),
        )..forward(),
      ),
    );

    _textCtrl.clear();
    setState(() => isWritting = false);

    socketBloc.socket.emit('mensaje-personal', {
      'from': authBloc.user.uid,
      'to': chatBloc.userTo.uid,
      'message': text
    });
  }

  void _listenMessage(dynamic data) {
    final message = ChatMessage(
      texto: data['message'],
      uid: data['from'],
      myUid: context.bloc<AuthenticationBloc>().state.user.uid,
      animationController: new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 250),
      ),
    );
    this._messagesWidget.insert(0, message);
    setState(() {});

    message.animationController.forward();
  }
}
