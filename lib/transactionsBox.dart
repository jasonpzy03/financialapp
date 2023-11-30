import 'package:flutter/material.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';

class TransactionBox extends StatelessWidget {

  final TransactionData transaction;
  late String note;
  late DateTime date;
  late double amount;
  late String account;
  late String category;
  late String transactType;

  TransactionBox({required this.transaction}) {
    this.note = transaction.note;
    this.date = transaction.date;
    this.account = transaction.account;
    this.amount = transaction.amount;
    this.category = transaction.category;
    this.transactType = transaction.transactType;
  }

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
                  Text(DateFormat('EEEE').format(date),
                      style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                  Text(DateFormat('yyyy-MM-dd').format(date),
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
                        width: 125,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note, style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(category, style: TextStyle(color: Colors.white, fontSize:15)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(account, style: TextStyle(color: Colors.grey, fontSize:15)),
                            ]
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 100,
                    child: FittedBox(alignment: Alignment.centerRight, fit: BoxFit.scaleDown,child: Text((transactType == "Expense" ? "- " : transactType == "Income" ? "+ ": "") + "\$" + amount.toStringAsFixed(2), style: TextStyle(color: (transactType == "Expense" ? Colors.red.shade300 : transactType == "Income" ? Colors.green.shade300 : Colors.white), fontSize:20, fontWeight: FontWeight.bold), textAlign: TextAlign.right,)),
                  )

                ],
              )



            ],





          )
      ),
    );


  }
}
