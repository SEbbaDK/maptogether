import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:client/widgets/app_bar.dart';
import 'package:client/database.dart';
import 'package:client/login_handler.dart';
import 'package:client/screens/social_screen.dart';

class LoginWebView extends StatelessWidget{

  final String url;
  void Function(BuildContext) onVerified;
  LoginWebView(this.url, this.onVerified);
    
  Completer<WebViewController> webViewController = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {

	final loginHandler = context.watch<LoginHandler>();

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    onWebViewCreated: (WebViewController c){
                        webViewController.complete(c);
                    },
                    // javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: url,
                    onPageStarted: (u) {
                        if (u.contains('maptogether.sebba.dk/login'))
                        {
    						final verifier = u.split('verifier=')[1];
    						print('Verifier: $verifier');
							loginHandler.authorize(verifier).then((_) {
								onVerified(context);
							});
                            Navigator.pop(context);
                        }
                    },
                ),
            )
          ],
        ),
    );
  }
}

  AlertDialog notLoggedInSocial(BuildContext context, void Function() optin){
    return AlertDialog(
      title: Text('You must be logged in to access social features'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Login to access the social features'),
        ],
      ),
      actions: <Widget>[
        Container(
            color: Colors.lightGreen,
            child: TextButton(
              onPressed: (){
                optin();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FutureBuilder<String>(
                        future: context.watch<LoginHandler>().loginUrl(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                        	(snapshot.hasData)
                        		? LoginWebView(snapshot.data, (c) { Navigator.push(c, MaterialPageRoute(builder: (context) => SocialScreen())); })
                        		: (snapshot.hasError)
                        			? Text('Error: ${snapshot.error}')
                                	: CircularProgressIndicator(semanticsLabel: 'Getting auth url')
                    ))
                );
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            )
        ),
        Container(
            color: Colors.lightGreen,
            child: TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                'No Thanks',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            )
        ),
      ],
    );
  }

