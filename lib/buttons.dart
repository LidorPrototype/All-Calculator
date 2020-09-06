import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final color;
  final textColor;
  final String buttonText;
  final buttonTapped;

  MyButton({this.color, this.textColor, this.buttonText, this.buttonTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: new Container(
              color: color,
              child: new Center(
                child: new AutoSizeText(
                  buttonText,
                  style: TextStyle(color: textColor, fontSize: 22),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ),
    );
  }
}
