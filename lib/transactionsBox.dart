import 'package:flutter/material.dart';

class TransactionBox extends StatelessWidget {

  final String transactionName;
  final String category;
  final String date;
  final String money;
  final String expenseOrIncome;

  TransactionBox({required this.transactionName, required this.category, required this.date, required this.money, required this.expenseOrIncome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromRGBO(49, 54, 69, 1),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade900,
                    blurRadius: 5.0),
              ]),
          child:
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text("Today",
                      style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                  Text("23-11-2023",
                      style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                ]

              ),
              SizedBox(
                height: 20
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.fastfood_rounded,

                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10
                      ),
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(transactionName, style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(category, style: TextStyle(color: Colors.white, fontSize:15)),
                            ]
                        ),
                      ),
                    ],
                  ),

                  Text((expenseOrIncome == "expense" ? "- " : "+ ") + "\$" + money, style: TextStyle(color: (expenseOrIncome == "expense" ? Colors.red.shade300 :Colors.green.shade300), fontSize:20, fontWeight: FontWeight.bold)),
                ],
              )



            ],





          )
      ),
    );


  }
}
