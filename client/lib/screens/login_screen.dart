import 'package:flutter/material.dart';
import 'package:client/widgets/app_bar.dart';
import 'package:client/database.dart';
import 'package:provider/provider.dart';


class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapTogetherAppBar(
        title: "Oauth",
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
            child: TextButton(
                child: Text("Login to Oauth"),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.lightGreen)
              ),
             ),
            Text("Logged in as: " + context.watch<DummyDatabase>().currentUserName),
          ]
          ),
      )
    );
  }
}
