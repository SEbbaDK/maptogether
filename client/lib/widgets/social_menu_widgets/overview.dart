import 'package:client/widgets/social_menu_widgets/user_overview.dart';
import 'package:flutter/material.dart';
import 'Leaderboard.dart';
import 'User.dart';



class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {


  LeaderBoard dk = new LeaderBoard("DK", [
    User("Thomas", 50),
    User("Sebba", 250),
    User("Simon", 15),
    User("Phillip", 85)
  ]);

  LeaderBoard world = new LeaderBoard("World", [
      User("Thomass", 10),
      User("Sebbass", 20),
      User("Simon", 40),
      User("Phillipina", 30)
  ]);

  List<LeaderBoard> leaderboards;

  void InitState() {
    leaderboards = [dk, world];
  }

  //UI made under the assumption that we are Simon, should be automatically
  //checked once user sessions have been created

  int usIndex(LeaderBoard leaderBoard) {
    for (int x = 0; x < leaderBoard.users.length; x++) {
      if (leaderBoard.users[x].name == "Simon") {
        return x;
      }
    }
    return 0;
  }




  @override
  Widget build(BuildContext context) {
    InitState();
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
                            + (usIndex(leaderboards[index])+1).toString()
                            + "/"
                            + (leaderboards[index].users.length).toString()),
                        leading: Text(leaderboards[index].name),
                        onTap: (){

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

