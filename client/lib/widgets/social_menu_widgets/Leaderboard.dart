import 'package:flutter/cupertino.dart';

import 'User.dart';

class LeaderBoard{
  String name;
  List<User> users;

  LeaderBoard(String n, List<User> usrs){
    name = n;
    users = usrs;

    users.sort((a, b) => b.total.compareTo(a.total));
  }
}

class LeaderBoardView extends StatefulWidget
{
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoardView>{
  @override
  Widget build(BuildContext context){
    return Container(

    );
  }
}
