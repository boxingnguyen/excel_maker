import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  Function selectHandler;
  var btnTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: RaisedButton(
          child: Text(btnTitle),
          onPressed: selectHandler,
          color: Colors.blue,
          textColor: Colors.white,
        ));
  }

  Answer(String title, Function onPress, this.btnTitle) {
    this.btnTitle = title;
    this.selectHandler = onPress;
  }
}
