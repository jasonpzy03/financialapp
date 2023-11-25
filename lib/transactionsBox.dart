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
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10.0),
              ]),
          height: 75,
          child:
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
                    width: 20,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transactionName, style: TextStyle(color: Colors.black, fontSize:15, fontWeight: FontWeight.bold)),
                          Text(category),
                          Text(date)
                        ]
                    ),
                  ),
                ],
              ),
              Text((expenseOrIncome == "expense" ? "- " : "+ ") + "\$" + money, style: TextStyle(color: (expenseOrIncome == "expense" ? Colors.orange :Colors.green), fontSize:20, fontWeight: FontWeight.bold)),


            ],
          )
      ),
    );


  }
}
