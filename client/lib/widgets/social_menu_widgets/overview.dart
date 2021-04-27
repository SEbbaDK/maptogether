import 'package:client/widgets/social_menu_widgets/user_overview.dart';
import 'package:flutter/material.dart';
import 'Leaderboard.dart';
import 'User.dart';
import 'package:client/database.dart';



class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

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
              Expanded(
                  child: ListView.builder(
                    itemCount: leaderboards.length,
                    itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        title: Text("#"
                            + ((leaderboards[index].users.indexOf(currentUser)+1).toString())
                            + "/"
                            + (leaderboards[index].users.length).toString()),
                        leading: Text(leaderboards[index].name),
                        onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => LeaderBoardView(leaderBoard: leaderboards[index]),));
                        },

                      )
                    );
                 }
               )
              )
            ],
          ),
        ),
      ],
    );
  }
}

