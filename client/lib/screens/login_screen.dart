import 'dart:async';

import 'package:client/login_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebView extends StatelessWidget {
  final String url;
  void Function(BuildContext) onVerified;

  LoginWebView(this.url);

  Completer<WebViewController> webViewController =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    final loginHandler = context.watch<LoginHandler>();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              onWebViewCreated: (WebViewController c) {
                webViewController.complete(c);
              },
              // javascriptMode: JavascriptMode.unrestricted,
              initialUrl: url,
              onPageFinished: (u) {
                if (u.contains('maptogether.sebba.dk/login')) {
                  final verifier = u.split('verifier=')[1];
                  print('Verifier: $verifier');
                  loginHandler.authorize(verifier).then((_) {
                    onVerified(context);
                  });
                  Navigator.of(context).pop(true);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

MaterialPageRoute<bool> loginPage() => MaterialPageRoute<bool>(
    builder: (context) => FutureBuilder<String>(
        future: context.watch<LoginHandler>().loginUrl(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
            (snapshot.hasData)
                ? LoginWebView(snapshot.data)
                : (snapshot.hasError)
                    ? Text('Error: ${snapshot.error}')
                    : CircularProgressIndicator(
                        semanticsLabel: 'Getting auth url')));

Future<bool> requestLogin(BuildContext context, {bool social}) => request(
      context,
      title: social
          ? 'You must login to access social features'
          : 'You must login to upload changes',
      body: social
          ? 'The social features are optional'
          : 'An OSM login is necessary to upload data',
      yes: 'Login',
      no: 'No Thanks',
    ).then((answer) async {
      if (answer == false) return false;

      return await Navigator.push<bool>(context, loginPage());
    });

Future<bool> request(BuildContext context,
    {String title, String body, String yes, String no}) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(body),
              ],
            ),
            actions: <Widget>[
              Container(
                  color: Colors.lightGreen,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      yes,
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  )),
              Container(
                  color: Colors.lightGreen,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      no,
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  )),
            ],
          ));
}
