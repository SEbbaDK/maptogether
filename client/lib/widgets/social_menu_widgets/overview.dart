import 'package:client/widgets/social_menu_widgets/user_overview.dart';
import 'package:flutter/material.dart';
import 'package:maptogether_api/maptogether_api.dart';
import 'Leaderboard.dart';
import 'User.dart';
import 'package:client/database.dart';
import 'package:provider/provider.dart';


class Overview extends StatefulWidget {
  @override
  _OverviewView createState() => _OverviewView();
}

class _OverviewView extends State<Overview> with TickerProviderStateMixin{
  //We get All, Weekly and Daily from the index of the tabcontroller, changes depending on which leaderboards we are interested in, 0 = daily, 1 = weekly, 2 = all
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
          child: TabBarView(
            controller: _nestedTabController,
            children: [
              leaderBoardWidget(LeaderboardType.weekly),
              leaderBoardWidget(LeaderboardType.montly),
              leaderBoardWidget(LeaderboardType.all_time),
            ])
        )
      ],
    );
  }


  Widget leaderBoardWidget(LeaderboardType type) =>
        FutureBuilder(
          future: getLeaderboards(),
          builder: (BuildContext context, AsyncSnapshot<List<Leaderboard>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                          title: Text("#"
                              + ((snapshot.data[index].entries.indexWhere((element) => element.user.name == "Peer") + 1).toString())
                              + "/"
                              + (snapshot.data[index].entries.length).toString()),
                          leading: Text("World"), //TODO: API should let us retrieve a leaderboard name
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LeaderBoardView(
                                          leaderboardIndex: index),));
                          },
                        )
                    );
                  }
              );
            }

            else {
              return SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              );
            }
          }
        );
}

Future<List<Leaderboard>> getLeaderboards() async{
  //This should call to get all the leaderboards in the future
  final api = MapTogetherApi();
  var l = await api.globalLeaderboard(LeaderboardType.all_time);
  List<Leaderboard> lst = [l];
  return lst;
}




