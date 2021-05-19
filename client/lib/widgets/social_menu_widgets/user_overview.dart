import 'package:client/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Leaderboard.dart';
import 'package:maptogether_api/maptogether_api.dart';
import 'package:client/data_fetchers.dart';

class UserOverView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot<User> user) {
          if (user.hasData) {
            return Container(
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
                      Text("Weekly   : " + user.data.score.toString(),
                        style: TextStyle(fontFamily: 'RobotoMono',
                            fontSize: 18,
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Monthly  : " + user.data.score.toString(),
                        style: TextStyle(fontFamily: 'RobotoMono',
                            fontSize: 18,
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("All time : " + user.data.score.toString(),
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
            );
          }

          else if(user.hasError)
            return errorData();

          else{
            return Container(
              padding: EdgeInsets.all(10.0),
                child: waitingLoop());
          }
        }
    );
  }
}
