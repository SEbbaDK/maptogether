import 'package:client/widgets/social/leaderboard.dart';
import 'package:client/widgets/social/add_friend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maptogether_api/maptogether_api.dart';
import 'package:client/data_fetchers.dart';


//TODO: move friends list to a seperate file or server
class Friends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final api = MapTogetherApi();

    return Container(
        child: FutureBuilder<User>(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot<User> user) {
              if (user.hasData) {
                return Column(
                  children: <Widget>[
                    Expanded(
                        flex: 14,
                        child: ListView.separated(
                            separatorBuilder: (BuildContext context,
                                int index) =>
                            const Divider(thickness: 2, height: 2),
                            itemCount: user.data.following.length,
                            itemBuilder: (context, index) {
                              return ListTile(
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
                                                print("UNFOLLOW SOMEONE");
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                title: Text(user.data.following[index].name),
                                leading: CircleAvatar(
                                  backgroundImage:
                                  AssetImage('assets/business.png'),
                                ),
                              );
                            }
                        )
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          color: Colors.lightGreen,
                          child: TextButton(
                            child: Text(
                              'Follow New',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => AddFriend()));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              else if(user.hasError)
                return errorData();

              else {
                return Expanded(
                    flex: 14,
                    child: waitingLoop());
              }
            }
        ));
  }
}

