import 'package:flutter/material.dart';

class Error extends StatelessWidget {

  final error;
  Error(this.error) { print(this.error); }
    
  @override
  build(BuildContext context) =>
    Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
            ),
            Text(error.toString()),
        ]
    );
}
