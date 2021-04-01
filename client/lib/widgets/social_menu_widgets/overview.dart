import 'package:client/widgets/social_menu_widgets/user_overview.dart';
import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
            child: UserOverView()
        ),
        Expanded(
          flex: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('leaderboards'),
              Text('leaderboards'),
              Text('leaderboards'),
              Text('leaderboards'),
            ],
          ),
        ),
      ],
    );
  }
}

