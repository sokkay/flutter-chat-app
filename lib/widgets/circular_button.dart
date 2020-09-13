import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final VoidCallback onPress;

  const CircularButton({
    Key key,
    this.color = Colors.blue,
    this.iconData = Icons.add,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          ),
          onTap: onPress,
        ),
      ),
    );
  }
}
