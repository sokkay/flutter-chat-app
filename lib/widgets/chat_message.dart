import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;
  final String myUid;

  const ChatMessage({
    Key key,
    @required this.texto,
    @required this.uid,
    this.animationController,
    @required this.myUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return animationController != null
        ? FadeTransition(
            opacity: animationController,
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                  parent: animationController, curve: Curves.easeInOut),
              child: _message(),
            ),
          )
        : _message();
  }

  Widget _message() {
    return Container(
      child:
          this.uid == this.myUid ? _myMessage() : notMyMessage(),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 8, right: 5, left: 50),
        child: Text(this.texto, style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
            color: Color(0xff4D9EF6), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 8, right: 50, left: 5),
        child: Text(this.texto, style: TextStyle(color: Colors.black87)),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
