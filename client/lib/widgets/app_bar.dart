import 'package:flutter/material.dart';

class MapTogetherAppBar extends StatelessWidget implements PreferredSizeWidget {
  MapTogetherAppBar(
      {Key key,
      @required this.title,
      this.actionButtons})
      : super(key: key);

  String title;

  List<IconButton> actionButtons;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.lightGreen,
      actions: actionButtons,
    );
  }

  @override
  Size get preferredSize {
    return Size(double.infinity, 60);
  }
}
