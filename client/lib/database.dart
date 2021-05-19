import 'package:client/widgets/social_menu_widgets/User.dart';
import 'package:flutter/foundation.dart';

//We get the current user through their username, usernames are unique,
//for the purpose of testing we are Simon

class LeaderBoardTest{
  String name;
  List<UserTest> users;

  LeaderBoardTest(this.name, this.users){
    users.sort((a, b) => b.total.compareTo(a.total));
  }
}

class DummyDatabase with ChangeNotifier{

  String loginURL = "";
  String currentUserName;
  UserTest currentUser;

  List<UserTest> globalUsers;
  List<LeaderBoardTest> leaderboards;
  List<String> followingNames;
  List<UserTest> following;

  DummyDatabase() {
    currentUserName = "Simon";

  //This is the list of all users to ever use the app, it makes up the global leaderboard.
    globalUsers = [
      UserTest("Thomas", 40, 25, 15, "kid.png", "UK"),
      UserTest("Sebba", 250, 150, 55, "clean.png", "DK"),
      UserTest("Simon", 25, 15, 5, "business.png", "DK"),
      UserTest("Phillip", 55, 35, 15, "arthas.png", "DK"),
      UserTest("Hartvig", 10, 10, 0, "anime.png", "JP"),
      UserTest("Fjeldsø", 20, 20, 10, "wolf.png", "DK"),
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
    LeaderBoardTest national = new LeaderBoardTest(currentUser.nationality,
        globalUsers.where((user) => user.nationality == currentUser.nationality)
            .toList());

    following = globalUsers.where((user) =>
        followingNames.contains(user.name)).toList();

    LeaderBoardTest world = new LeaderBoardTest("World", globalUsers);

    LeaderBoardTest followLB = new LeaderBoardTest("Follow", following);

    leaderboards = [world, national, followLB];


  }

  void givePoints(int x){
    currentUser.total += x;
    notifyListeners();
  }

  void followNew(String toFollow){
    UserTest userToFollow = globalUsers.firstWhere((user) => user.name == toFollow, orElse: () => null);
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
