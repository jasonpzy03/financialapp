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
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade50,
                  offset: Offset(0.0, 10.0),
                  blurRadius: 5.0,),
              ]),
          child:
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text(DateFormat('EEEE').format(date),
                      style: TextStyle(color: Colors.black, fontSize:15, fontWeight: FontWeight.bold)),
                  Text(DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(color: Colors.black, fontSize:15, fontWeight: FontWeight.bold)),
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
                        width: 125,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note, style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:18, fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(category, style: TextStyle(color: Colors.grey, fontSize:15, fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(account, style: TextStyle(color: Colors.grey[700], fontSize:15, fontWeight: FontWeight.bold)),
                            ]
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 100,
                    child: FittedBox(alignment: Alignment.centerRight, fit: BoxFit.scaleDown,child: Text((transactType == "Expense" ? "- " : transactType == "Income" ? "+ ": "") + "RM " + amount.toStringAsFixed(2), style: TextStyle(color: (transactType == "Expense" ? Color.fromRGBO(250, 69, 110, 1) : transactType == "Income" ? Color.fromRGBO(4, 207, 164, 1) : Colors.white), fontSize:20, fontWeight: FontWeight.bold), textAlign: TextAlign.right,)),
                  )

                ],
              )



            ],





          )
      ),
    );


  }
}
