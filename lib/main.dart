import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:nerdboard/views/LoginPage.dart';
import 'package:nerdboard/views/SignUpPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    'ewDM6XDAleJE6OVhy8VMDhUmk14aalOy6MeTdEK6',
    'https://parseapi.back4app.com/',
    clientKey: 'q12UT7viYBz9UGkuEORk1kM72oknZ8eNhAzOU2e0',
    autoSendSessionId: true,
    debug: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NERD BOARD',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}

