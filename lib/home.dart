import 'package:flutter/material.dart';
import '../accounts.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 60.0, left: 30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Balance",
                      style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
                  SizedBox(
                      height:10
                  ),
                  Row(
                    children: [
                      Text("\$", style: TextStyle(color: Colors.white, fontSize:25, fontWeight: FontWeight.bold)),
                      SizedBox(
                          width:10
                      ),
                      Text("200,000",
                          style: TextStyle(color: Colors.white, fontSize:45, fontWeight: FontWeight.bold)),
                      SizedBox(
                          width:10
                      ),
                      Text(".64",
                          style: TextStyle(color: Colors.white, fontSize:25, fontWeight: FontWeight.bold)),
                    ],
                  )
                ]
            )
        ),
        SizedBox(
            height:20
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cashflow",
                  style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
              Text("See more",
                  style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0, right: 70.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(49, 54, 69, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Inflow",
                          style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
                      SizedBox(
                          height:15
                      ),
                      Row(
                        children: [
                          Text("\$ 3200",
                              style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                          Text(".64",
                              style: TextStyle(color: Colors.white, fontSize:13, fontWeight: FontWeight.bold)),
                        ],
                      )

                    ],
                  )
              ),
              Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0, right: 70.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(49, 54, 69, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Outflow",
                          style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
                      SizedBox(
                          height:15
                      ),
                      Row(
                        children: [
                          Text("\$ 1200",
                              style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                          Text(".64",
                              style: TextStyle(color: Colors.white, fontSize:13, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
        //TopNewCard(balance: "20,000.00", income: "3,200.00", expense: "1,200.00", total: "2,000.00",),
        SizedBox(
            height: 40
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Accounts",
                  style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
              Text("See more",
                  style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Container(
          height: 175,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                Account(accountName: "Touch N Go", balance: "3,000", decimal: ".64", bgColor: Colors.cyan),
                Account(accountName: "Versa Cash", balance: "20,000", decimal: ".94", bgColor: Colors.lightGreen),
                Account(accountName: "ASNB", balance: "100,000", decimal: ".99", bgColor: Colors.blue),
              ],
            ),
          ),
        ),

        // Expanded(
        //   child: Container(
        //     padding: EdgeInsets.symmetric(horizontal: 20.0),
        //     child: ListView(
        //       physics: BouncingScrollPhysics(),
        //       children: [
        //         Transaction(transactionName: "吉面家", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "expense"),
        //         Transaction(transactionName: "吉面家", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "expense"),
        //         Transaction(transactionName: "AAPL Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
        //         Transaction(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
        //         Transaction(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
        //         Transaction(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
        //         Transaction(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
        //         Transaction(transactionName: "SPY Stock", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "income"),
        //
        //       ],
        //     ),
        //   ),
        // ),
        SizedBox(
            height: 50
        ),

      ],
    );


  }
}
