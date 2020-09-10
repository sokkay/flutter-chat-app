import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textCtrl = new TextEditingController();
  final _focusNode = new FocusNode();
  bool isWritting = false;

  List<ChatMessage> _messages = [];

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    // this.socketService.socket.on('mensaje-personal', _listenMessage);
    _loadHistory(this.chatService.usuarioTo.uid);
  }

  @override
  Widget build(BuildContext context) {
    final user = chatService.usuarioTo;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                user.name.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              user.name,
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
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
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
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    _messages.forEach((m) => m.animationController?.dispose());
    // this.socketService.socket.off('mensaje-personal');
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

    _messages.insert(
      0,
      new ChatMessage(
        uid: authService.usuario.uid,
        texto: text,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 250),
        )..forward(),
      ),
    );

    _textCtrl.clear();
    setState(() => isWritting = false);

    this.socketService.emit('mensaje-personal', {
      'from': authService.usuario.uid,
      'to': chatService.usuarioTo.uid,
      'message': text
    });
  }

  void _listenMessage(dynamic data) {
    final message = ChatMessage(
      texto: data['message'],
      uid: data['from'],
      animationController: new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 250),
      ),
    );
    this._messages.insert(0, message);
    setState(() {});

    message.animationController.forward();
  }

  void _loadHistory(String uid) async {
    final chat = await this.chatService.getChat(uid);
    final history = chat.map(
      (e) => new ChatMessage(
        texto: e.message,
        uid: e.from,
      ),
    );
    setState(() {
      _messages.insertAll(0, history);
    });
  }
}
