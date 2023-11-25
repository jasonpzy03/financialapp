import 'package:flutter/material.dart';
import '../transactionsBox.dart';

class Transaction extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                TransactionBox(transactionName: "吉面家", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "expense"),
                TransactionBox(transactionName: "吉面家", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "expense"),
                TransactionBox(transactionName: "AAPL Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
                TransactionBox(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
                TransactionBox(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
                TransactionBox(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
                TransactionBox(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
                TransactionBox(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),

              ],
            ),
          ),
        ),

      ],
    );


  }
}
