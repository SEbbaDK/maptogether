import 'package:client/widgets/social/user_overview.dart';
import 'package:flutter/material.dart';
import 'package:maptogether_api/maptogether_api.dart';
import 'leaderboard.dart';
import 'package:provider/provider.dart';
import 'package:client/data_fetchers.dart';


class Overview extends StatefulWidget {
  @override
  _OverviewView createState() => _OverviewView();
}

class _OverviewView extends State<Overview> with TickerProviderStateMixin{
  //We get All, Weekly and Daily from the index of the tabcontroller, changes depending on which leaderboards we are interested in, 0 = daily, 1 = weekly, 2 = all
  TabController _nestedTabController;
  List<String> lboards;

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
                text: "All Time",
              ),
              Tab(
                text: "Monthly",
              ),
              Tab(
                text: "Weekly",
              ),
            ]
        ),

        Expanded(
          flex: 7,
          child: TabBarView(
            controller: _nestedTabController,
            children: [
              leaderBoardWidget(LeaderboardType.all_time),
              leaderBoardWidget(LeaderboardType.monthly),
              leaderBoardWidget(LeaderboardType.weekly),
            ])
        )
      ],
    );
  }


  //TODO: make future builder dependent

  Widget leaderBoardWidget(LeaderboardType type) =>
        FutureBuilder(
          future: getLeaderboard(type, "global"), //replace this once we have call to get all leaderboard names for user
          builder: (BuildContext context, AsyncSnapshot<Leaderboard> snapshot) {
            lboards = getLeaderboardNames();
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: lboards.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                          //title: Text("#" + ((snapshot.data[index].entries.indexWhere((element) => element.user.name == "Peer") + 1).toString()) + "/"+ (snapshot.data[index].entries.length).toString()),
                          leading: Text(lboards[index].toString()), //TODO: API should let us retrieve a leaderboard name
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LeaderBoardView(
                                          leaderBoardName: lboards[index], type: type,),));
                          },
                        )
                    );
                  }
              );
            }

            else if(snapshot.hasError)
              return errorData();

            else
              return waitingLoop();
          }
        );
}




