import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String askTitle;
  final String title;

  const Labels({
    Key key,
    this.route,
    @required this.askTitle,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            askTitle,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, route);
            },
            child: Text(
              title,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            'Términos y condiciones de uso',
            style: TextStyle(
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
