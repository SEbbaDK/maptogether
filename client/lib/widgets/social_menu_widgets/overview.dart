import 'package:client/widgets/social_menu_widgets/user_overview.dart';
import 'package:flutter/material.dart';
import 'Leaderboard.dart';
import 'User.dart';
import 'package:client/database.dart';
import 'package:provider/provider.dart';


class Overview extends StatefulWidget {
  @override
  _OverviewView createState() => _OverviewView();
}

class _OverviewView extends State<Overview> with TickerProviderStateMixin{
  //Modes are All, Weekly and Daily, changes depending on which leaderboards we are interested in
  String mode = "All";
  TabController _nestedTabController;

  @override
  void initState(){
    super.initState();

    _nestedTabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose(){
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
            child: UserOverView()
        ),
        TabBar(
            controller: _nestedTabController,
            indicatorColor: Colors.green,
            labelColor: Colors.lightGreen,
            unselectedLabelColor: Colors.black,
            isScrollable: false,
            tabs: <Widget>[
              Tab(
                text: "Daily",
              ),
              Tab(
                text: "Weekly",
              ),
              Tab(
                text: "All Time",
              ),
            ]
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
                                    builder: (context) => LeaderBoardView(leaderboardIndex: index),));
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

