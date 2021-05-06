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

class WebViewContainer extends StatefulWidget{
  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url = "https://www.duckduckgo.com";
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
                    initialUrl: _url),
            )
          ],
        ),
    );
  }
}

