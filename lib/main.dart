import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:nerdboard/pages/LoginPage.dart';
import 'package:nerdboard/pages/SignUpPage.dart';
import 'package:nerdboard/pages/RankingPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final keyApplicationId = 'ewDM6XDAleJE6OVhy8VMDhUmk14aalOy6MeTdEK6';
  final keyClientKey = 'q12UT7viYBz9UGkuEORk1kM72oknZ8eNhAzOU2e0';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignUpProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'NERD BOARD',
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/ranking': (context) => RankingPage(),
        },
      ),
    );
  }
}
