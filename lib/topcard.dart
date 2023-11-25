import 'package:flutter/material.dart';

class TopNewCard extends StatelessWidget {

  final String balance;
  final String income;
  final String expense;
  final String total;


  TopNewCard({required this.balance, required this.expense, required this.income, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10.0),
            ]),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Balance",
                      style: TextStyle(color: Colors.grey[600], fontSize:20)),
                Text(
                    '\$' + balance,
                    style: TextStyle(color: Colors.black, fontSize:30, fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[100],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                              children: [
                                Text("Income",
                                  style: TextStyle(
                                      color: Colors.grey[600])),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('\$' + income,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ]
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[100],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                              children: [
                                Text("Expense",
                                    style: TextStyle(
                                        color: Colors.grey[600])),
                                Text('\$' + expense,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ]
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[100],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.equalizer,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                              children: [
                                Text("Total",
                                    style: TextStyle(
                                        color: Colors.grey[600])),
                                Text('\$' + total,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ]
                          )
                        ],
                      )
                    ],
                  )

                ),
              ]
            ),
      )
    );
  }
}
