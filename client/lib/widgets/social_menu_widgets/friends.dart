import 'package:client/widgets/social_menu_widgets/Leaderboard.dart';
import 'package:client/widgets/social_menu_widgets/newFriend.dart';
import 'package:flutter/material.dart';
import 'User.dart';
import 'package:client/database.dart';
import 'package:provider/provider.dart';
import 'package:maptogether_api/maptogether_api.dart';


//TODO: move friends list to a seperate file or server
class Friends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final api = MapTogetherApi();

    return Container(
      margin: EdgeInsets.all(40.0),
      child: Column(
        children: <Widget>[
          Expanded(flex: 1, child: Text("Following")),
          FutureBuilder<Leaderboard>(
            future: api.globalLeaderboard(LeaderboardType.all_time),
            builder: (BuildContext context, AsyncSnapshot<Leaderboard> snapshot) {
                return Expanded(
                    flex: 7,
                    child: ListView.builder(
                        itemCount: context
                            .watch<DummyDatabase>()
                            .following
                            .length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onLongPress: () {
                                showModalBottomSheet <void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 100,
                                        color: Colors.orange,
                                        child: Center(
                                          child: TextButton(
                                            child: Text("Unfollow"),
                                            style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor: Colors.red
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<DummyDatabase>()
                                                  .followingNames
                                                  .remove(context
                                                  .read<DummyDatabase>()
                                                  .following[index].name);
                                              context
                                                  .read<DummyDatabase>()
                                                  .following
                                                  .removeAt(index);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                );
                              },
                              title: Text(context
                                  .watch<DummyDatabase>()
                                  .following[index].name),
                              leading: CircleAvatar(
                                backgroundImage:
                                AssetImage('assets/${context
                                    .watch<DummyDatabase>()
                                    .following[index].pfp}'),
                              ),
                            ),
                          );
                        }
                    )
                );
              }
      ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                color: Colors.lightGreen,
                child: TextButton(
                  child: Text(
                    'Follow New',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewFriend()));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
