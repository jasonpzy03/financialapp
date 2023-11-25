import 'package:flutter/material.dart';
import '../transactionsBox.dart';

class Transaction extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 60.0, left: 30.0),
          child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("< Nov 2023 >",
                      style: TextStyle(color: Colors.white, fontSize:18, fontWeight: FontWeight.bold)),
                  SizedBox(
                      height: 15
                  ),
                  Text("Transactions",
                      style: TextStyle(color: Colors.white, fontSize:30, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10
                  ),
                  Text("Cashflow",
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
                      Text("2,000",
                          style: TextStyle(color: Colors.white, fontSize:45, fontWeight: FontWeight.bold)),
                      SizedBox(
                          width:10
                      ),
                      Text(".64",
                          style: TextStyle(color: Colors.white, fontSize:25, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              )

        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 30),
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
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                TransactionBox(transactionName: "吉面家", category: "Food", date: "24, Fri", money: "20", expenseOrIncome: "expense"),

              ],
            ),
          ),
        ),

      ],
    );


  }
}
