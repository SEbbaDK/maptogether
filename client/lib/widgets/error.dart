import 'package:flutter/material.dart';

class Error extends StatelessWidget {

  final error;
  Error(this.error) { print(this.error); }
    
  @override
  build(BuildContext context) =>
    Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
    );
}
