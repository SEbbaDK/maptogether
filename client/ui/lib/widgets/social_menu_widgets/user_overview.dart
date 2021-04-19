import 'package:flutter/material.dart';

class UserOverView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FittedBox(
              child: Icon(
                Icons.person,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
