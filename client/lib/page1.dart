import 'package:client/page2.dart';
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async{
        var navigationResult = await Navigator.push(context, new MaterialPageRoute(
            builder: (context) => Page2()
        ));
        if(navigationResult == true){
          showDialog(context: context,
              builder: (context)=> AlertDialog(title: Text('Navigation result success'),));
        }
      },),
      body: Container(
        child: Center(
          child: Text(
            'Page 1',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}