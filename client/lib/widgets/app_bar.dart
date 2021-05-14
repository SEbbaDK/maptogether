import 'package:flutter/material.dart';

class MapTogetherAppBar extends StatelessWidget implements PreferredSizeWidget {
  MapTogetherAppBar(
      {Key key,
      @required this.title,
      this.actions})
      : super(key: key);

  String title;

  List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.lightGreen,
      actions: actions,
    );
  }

  @override
  Size get preferredSize {
    return Size(double.infinity, 60);
  }
}
