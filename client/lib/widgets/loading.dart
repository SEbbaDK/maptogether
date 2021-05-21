import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
    @override
    build(BuildContext context) =>
          SizedBox(
            child: CircularProgressIndicator(),
              width: 60,
              height: 60,
        );
}
