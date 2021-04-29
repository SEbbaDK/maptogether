import 'package:client/widgets/social_menu_widgets/user_overview.dart';
import 'package:flutter/material.dart';
import 'Leaderboard.dart';
import 'User.dart';
import 'package:client/database.dart';
import 'package:provider/provider.dart';



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
                    itemCount: context.watch<DummyDatabase>().leaderboards.length,
                    itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        title: Text("#"
                            + ((context.watch<DummyDatabase>().leaderboards[index].users.indexOf(context.watch<DummyDatabase>().currentUser)+1).toString())
                            + "/"
                            + (context.watch<DummyDatabase>().leaderboards[index].users.length).toString()),
                        leading: Text(context.watch<DummyDatabase>().leaderboards[index].name),
                        onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => LeaderBoardView(leaderBoard: context.watch<DummyDatabase>().leaderboards[index]),));
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

