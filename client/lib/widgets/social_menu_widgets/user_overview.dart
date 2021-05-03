import 'package:client/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserOverView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('assets/${context.watch<DummyDatabase>().currentUser.pfp}'),
              )
            )

            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Daily    : " + context.watch<DummyDatabase>().currentUser.daily.toString(),
              style: TextStyle(fontFamily: 'RobotoMono', fontSize: 18, color: Colors.lightGreen, fontWeight: FontWeight.bold),
              ),
              Text("Weekly  : " + context.watch<DummyDatabase>().currentUser.weekly.toString(),
                style: TextStyle(fontFamily: 'RobotoMono', fontSize: 18, color: Colors.lightGreen, fontWeight: FontWeight.bold),
              ),
              Text("All time : " + context.watch<DummyDatabase>().currentUser.total.toString(),
                style: TextStyle(fontFamily: 'RobotoMono', fontSize: 18, color:Colors.lightGreen, fontWeight: FontWeight.bold
              )
              )
            ],
          )
        ],
      ),
    );
  }
}
