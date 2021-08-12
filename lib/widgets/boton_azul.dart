import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final Function onPressed;
  final String text;

  const BotonAzul({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(2),
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            shape: MaterialStateProperty.all(StadiumBorder())),
        onPressed: () => this.onPressed(),
        child: Container(
          height: 55,
          width: double.infinity,
          child: Center(
            child: Text(
              '${this.text}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ));
  }
}
