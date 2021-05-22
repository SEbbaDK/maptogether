import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:client/login_handler.dart';
import 'package:client/widgets/app_bar.dart';
import 'package:client/widgets/future_loader.dart';

class LoginWebView extends StatelessWidget {
  final String url;

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
                    Navigator.of(context).pop(true);
                  });
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
    builder: (context) => FutureLoader<String>(
        future: context.watch<LoginHandler>().loginUrl(),
        builder: (BuildContext context, String url) => LoginWebView(url)));

Future<bool> requestLogin(BuildContext context, {bool social = false}) =>
    request(
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
      final login = await Navigator.push<bool>(context, loginPage());
      if (login && social) await context.read<LoginHandler>().optIn();
      return login;
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
