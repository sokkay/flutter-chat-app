import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ButtonBlue({
    Key key,
    @required this.onPressed,
    this.text = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      onPressed: onPressed,
      child: Container(
        width: double.maxFinite,
        height: 55,
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
