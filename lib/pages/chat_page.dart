import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textCtrl = new TextEditingController();
  final _focusNode = new FocusNode();
  bool isWritting = false;

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              'Javier',
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
    _messages.forEach((m) => m.animationController.dispose());
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
    print(text);
    _messages.insert(
      0,
      new ChatMessage(
        uid: '123',
        texto: text,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 250),
        )..forward(),
      ),
    );

    _textCtrl.clear();
    setState(() => isWritting = false);
  }
}
