import 'package:client/widgets/social_menu_widgets/Leaderboard.dart';
import 'package:client/widgets/social_menu_widgets/User.dart';

//We get the current user through their username, usernames are unique,
//for the purpose of testing we are Simon
String currentUserName = "Simon";
User currentUser = globalUsers.firstWhere((user) => user.name == currentUserName);

//This is the list of all users,
List<User> globalUsers = [
  User("Thomas", 50, "kid.png", "UK"),
  User("Sebba", 250, "clean.png", "DK"),
  User("Simon", 25, "business.png", "DK"),
  User("Phillip", 85, "arthas.png", "DK"),
  User("Hartvig", 10, "anime.png", "JP"),
  User("Fjeldsø", 20, "wolf.png", "DK"),
];

LeaderBoard national = new LeaderBoard(currentUser.nationality, globalUsers.where((user) => user.nationality == currentUser.nationality).toList());

LeaderBoard world = new LeaderBoard("World", globalUsers);

List<LeaderBoard> leaderboards = [world, national];

List<String> followingNames = [
  "Thomas",
  "Hartvig",
  "Sebba",
  "Fjeldsø",
  "Phillip",
];

List<User> following = globalUsers.where((user) => followingNames.contains(user.name)).toList();