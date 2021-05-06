import 'dart:async';

import 'package:flutter/material.dart';
import 'package:client/widgets/app_bar.dart';
import 'package:client/database.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';


class Login extends StatelessWidget {

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
                    backgroundColor: Colors.lightGreen),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewContainer()));

                },
              ),
             ),
            Text("Logged in as: " + context.watch<DummyDatabase>().currentUserName),
          ]
          ),
      )
    );
  }
}


class WebViewContainer extends StatelessWidget{
  var initialUrl = "https://www.duckduckgo.com";
  Completer<WebViewController> webViewController = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    onWebViewCreated: (WebViewController c){
                        webViewController.complete(c);
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: initialUrl),
            )
          ],
        ),
      floatingActionButton: loginFinished(),
    );
  }
  Widget loginFinished() {
    return FutureBuilder<WebViewController>(
        future: webViewController.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = (await controller.data.currentUrl());
                Provider.of<DummyDatabase>(context, listen: false).loginURL = url;
                // ignore: deprecated_member_use
                print("Succesfully saves url: $url");

                showDialog(context: context, builder: (_) => AlertDialog(
                  title: Text('Succesfully logged url: $url!'),
                  actions: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      color: Colors.lightGreen,
                      child: TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("Okay",
                                      style: TextStyle(fontSize: 14.0, color: Colors.white))),
                    ),
                  ],
                ));

              },
              child: const Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }

}

