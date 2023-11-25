import 'package:flutter/material.dart';
import '../transactions.dart';
import '../home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  final tabs = [
      Home(),
      Transactions()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 38, 51, 100),
      body: tabs[_currentIndex],
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: null
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color.fromRGBO(35, 38, 51, 100),
        unselectedItemColor: Colors.grey[350],
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: "Transactions"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: "Accounts"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: "More"
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
