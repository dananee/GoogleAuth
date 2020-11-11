import 'package:flutter/material.dart';
import 'package:flutter_linkedin/linkedloginflutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final String clientId = '77l8g3u52ai9r3';
  final String redirectUrl = 'https://www.fricourse.com';
  final String clientSecret = 'QZwtJPPvCTPWaJtB';
  @override
  void initState() {
    super.initState();
    LinkedInLogin.initialize(context,
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUri: redirectUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: OutlineButton(
            onPressed: () {
              LinkedInLogin.loginForAccessToken(
                destroySession: true,
                appBar: AppBar(
                  title: Text('Wow Worked'),
                ),
              ).then((accessToken) => print(accessToken)).catchError((error) {
                print(error.errorDescription);
              });
            },
            borderSide: BorderSide(
              color: Colors.black,
              style: BorderStyle.solid,
            ),
            child: Text('LinkedIn'),
          ),
        ),
      ),
    );
  }
}
