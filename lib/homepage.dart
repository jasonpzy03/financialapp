import 'package:flutter/material.dart';
import '../transactionspage.dart';
import '../accounts.dart';
import '../homepagecontent.dart';
import 'package:ui_practice_1/db/budgetexpense.dart';
import 'package:ui_practice_1/editTransactionPage.dart';
import 'package:ui_practice_1/model/transaction.dart';

class HomePage extends StatefulWidget {

  int currentIndex = 0;

  HomePage(currentIndex, {super.key}) {
    this.currentIndex = currentIndex;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.currentIndex;

  }

  final tabs = [
      HomePageContent(),
      TransactionsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 38, 51, 1.0),
      body: tabs[_currentIndex],
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.pushNamed(context, '/transactionDataPage');
          }
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color.fromRGBO(38, 41, 59, 1.0),
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
