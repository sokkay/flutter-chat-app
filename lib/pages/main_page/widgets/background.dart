import 'package:flutter/material.dart';

class ChatsBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: 40,
            child: circle(size, radius: size.width * 0.4),
          ),
          Positioned(
            left: size.width / 3,
            top: size.width * 0.2,
            child: circle(size, radius: size.width * 0.1),
          ),
          Positioned(
            left: 10,
            top: size.width * 0.4,
            child: circle(size, radius: size.width * 0.3),
          ),
        ],
      ),
    );
  }

  Widget circle(Size size, {@required double radius}) => Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50],
              Colors.purple[50].withOpacity(0.1),
              Colors.purple[50].withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(size.width),
        ),
      );
}
