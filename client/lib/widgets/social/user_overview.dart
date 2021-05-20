import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maptogether_api/maptogether_api.dart';

import 'package:client/widgets/future_loader.dart';

class UserOverview extends StatelessWidget {
  Future<User> user;
  UserOverview(this.user);
    
  @override
  Widget build(BuildContext context) =>
    FutureLoader<User>(
        future: user,
        builder: (BuildContext context, User user) =>
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/business.png'),
                          )
                      )

                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Score : ${user.score}",
                          style: TextStyle(fontFamily: 'RobotoMono',
                              fontSize: 18,
                              color: Colors.lightGreen,
                              fontWeight: FontWeight.bold
                          )
                      )
                    ],
                  )
                ],
              ),
            )
    );
}
