import 'package:flutter/material.dart';

class ButtonRow extends StatelessWidget {
  const ButtonRow({Key key, this.buttons}) : super(key: key);

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    widgets.add(SizedBox(width: 5));
    for (int i = 0; i < buttons.length; i++) {
      widgets.add(buttons[i]);
      widgets.add(SizedBox(width: 5));
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widgets,
      ),
    );
  }
}