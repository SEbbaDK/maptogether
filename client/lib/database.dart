import 'package:client/widgets/social_menu_widgets/Leaderboard.dart';
import 'package:client/widgets/social_menu_widgets/User.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

//We get the current user through their username, usernames are unique,
//for the purpose of testing we are Simon

class DummyDatabase with ChangeNotifier{

  String loginURL = "";
  String currentUserName;
  User currentUser;

  List<User> globalUsers;
  List<LeaderBoard> leaderboards;
  List<String> followingNames;
  List<User> following;

  DummyDatabase() {
    currentUserName = "Simon";

  //This is the list of all users to ever use the app, it makes up the global leaderboard.
    globalUsers = [
      User("Thomas", 40, 25, 15, "kid.png", "UK"),
      User("Sebba", 250, 150, 55, "clean.png", "DK"),
      User("Simon", 25, 15, 5, "business.png", "DK"),
      User("Phillip", 55, 35, 15, "arthas.png", "DK"),
      User("Hartvig", 10, 10, 0, "anime.png", "JP"),
      User("Fjeldsø", 20, 20, 10, "wolf.png", "DK"),
    ];

    followingNames = [
      "Thomas",
      "Hartvig",
      "Sebba",
      "Fjeldsø",
      "Phillip",
    ];

    //currentUser found in the global list through
    currentUser = globalUsers.firstWhere((user) =>
    user.name == currentUserName);

    //Setting up Leaderboards
    LeaderBoard national = new LeaderBoard(currentUser.nationality,
        globalUsers.where((user) => user.nationality == currentUser.nationality)
            .toList());

    following = globalUsers.where((user) =>
        followingNames.contains(user.name)).toList();

    LeaderBoard world = new LeaderBoard("World", globalUsers);

    LeaderBoard followLB = new LeaderBoard("Follow", following);

    leaderboards = [world, national, followLB];


  }

  void givePoints(int x){
    currentUser.total += x;
    notifyListeners();
  }

  void followNew(String toFollow){
    User userToFollow = globalUsers.firstWhere((user) => user.name == toFollow, orElse: () => null);
    if(userToFollow == null)
      print("User does not exist");

    else if(followingNames.contains(toFollow))
      print("Already following");

    else {
      followingNames.add(toFollow);
      following.add(userToFollow);
    }

    notifyListeners();
  }

}
