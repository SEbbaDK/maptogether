import 'package:flutter/material.dart';

class MapTogetherAppBar extends StatelessWidget implements PreferredSizeWidget {
  MapTogetherAppBar(
      {Key key,
      @required this.title,
      this.bottom,
      this.actionButtons})
      : super(key: key);

  String title;
  PreferredSizeWidget bottom;

  List<IconButton> actionButtons;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
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
