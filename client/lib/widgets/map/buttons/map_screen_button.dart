import 'package:flutter/material.dart';

class MapScreenButton extends StatelessWidget {
  MapScreenButton(
      {Key key,
      @required this.child,
      @required this.onPressed,
      this.height,
      this.width})
      : super(key: key);

  final Widget child;
  final Function onPressed;

  // standard height and width can be overwritten in initializer
  double height = 50, width = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        //shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(100),
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: IconButton(
          icon: child,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
