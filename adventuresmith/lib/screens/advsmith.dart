import 'package:adventuresmith/screens/dice_explorer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// home page for the app
class AdventuresmithHomePage extends StatefulWidget {
  /// ctor for the home page
  AdventuresmithHomePage({Key key}) : super(key: key);

  @override
  _AdventuresmithHomePageState createState() => _AdventuresmithHomePageState();
}

class _AdventuresmithHomePageState extends State<AdventuresmithHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    DiceExplorerPage(),
    Text(
      'Index 1: Roll!',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.diceMultiple),
            title: Text('Dice Stats'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.dice3),
            title: Text('Roll!'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
