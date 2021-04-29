import 'package:client/widgets/social_menu_widgets/Leaderboard.dart';
import 'package:client/widgets/social_menu_widgets/User.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

//We get the current user through their username, usernames are unique,
//for the purpose of testing we are Simon

class DummyDatabase with ChangeNotifier{

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
      User("Thomas", 50, "kid.png", "UK"),
      User("Sebba", 250, "clean.png", "DK"),
      User("Simon", 25, "business.png", "DK"),
      User("Phillip", 85, "arthas.png", "DK"),
      User("Hartvig", 10, "anime.png", "JP"),
      User("Fjeldsø", 20, "wolf.png", "DK"),
    ];

    //currentUser found in the global list through
    currentUser = globalUsers.firstWhere((user) =>
    user.name == currentUserName);

    //Setting up Leaderboards
    LeaderBoard national = new LeaderBoard(currentUser.nationality,
        globalUsers.where((user) => user.nationality == currentUser.nationality)
            .toList());

    LeaderBoard world = new LeaderBoard("World", globalUsers);

    leaderboards = [world, national];

    followingNames = [
      "Thomas",
      "Hartvig",
      "Sebba",
      "Fjeldsø",
      "Phillip",
    ];

    following = globalUsers.where((user) =>
        followingNames.contains(user.name)).toList();


  }

  void increment(){
    currentUser.total += 10;
    notifyListeners();
  }

}
