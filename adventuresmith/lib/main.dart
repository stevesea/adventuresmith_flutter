// ignore_for_file: public_member_api_docs
import 'package:adventuresmith/models/dice_expression_model.dart';
import 'package:adventuresmith/screens/advsmith.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

void main() {
  Logger.root.level = Level.FINE;

  Logger.root.onRecord.listen((rec) {
    print('$rec');
  });

  runApp(AdventuresmithApp());
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AdventuresmithHomePage());
      /*
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginView());
      case '/post':
        return MaterialPageRoute(builder: (_) => PostView());

         */
      default:
        return MaterialPageRoute(builder: (_) {
          return AdventuresmithHomePage();
        });
    }
  }
}

class AdventuresmithApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var testExpressions = DiceExpressions();
    testExpressions.add(DiceExpressionModel());
    testExpressions.add(DiceExpressionModel());
    testExpressions.add(DiceExpressionModel());
    testExpressions.add(DiceExpressionModel());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => testExpressions),
      ],
      child: MaterialApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
        //home: AdventuresmithHomePage(),
      ),
    );
  }
}
