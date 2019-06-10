// ignore_for_file: public_member_api_docs
import 'package:adventuresmith/models/dice_expression_model.dart';
import 'package:adventuresmith/screens/advsmith.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

void main() {
  Logger.root.level = Level.INFO;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => Counter()),
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

class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(builder: (context, counter, _) {
      return Scaffold(
        appBar: AppBar(title: const Title()),
        body: const Center(child: CounterLabel()),
        floatingActionButton: const IncrementCounterButton(),
      );
    });
  }
}

class IncrementCounterButton extends StatelessWidget {
  const IncrementCounterButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: Provider.of<Counter>(context).increment,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}

class CounterLabel extends StatelessWidget {
  const CounterLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'You have pushed the button this many times:',
        ),
        Text(
          '${counter.count}',
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return Text('Tapped ${counter.count} times');
  }
}
