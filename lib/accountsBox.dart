import 'package:flutter/material.dart';

import 'model/account.dart';

class AccountBox extends StatelessWidget {

  final AccountData account;
  late String accountGroup;
  late double amount;
  late String name;
  late String description;

  AccountBox({required this.account}) {
    this.accountGroup = account.accountGroup;
    this.name = account.name;
    this.description = account.description;
    this.amount = account.amount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          width: MediaQuery.sizeOf(context).width * 0.48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.shade50,
                  offset: Offset(0.0, 10.0),
                  blurRadius: 5.0,
                ),
              ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(name,
                    style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:25, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                  height:15
              ),
              Text("Total Balance: ",
                  style: TextStyle(color: Colors.black, fontSize:20, fontWeight: FontWeight.bold)),
              SizedBox(
                  height:20
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  child:
                      Text("RM " + amount.toStringAsFixed(2),
                          style: TextStyle(color: amount < 0 ? Color.fromRGBO(250, 69, 110, 1) : Color.fromRGBO(4, 207, 164, 1), fontSize:20, fontWeight: FontWeight.bold)),


                ),
              ),
            ],
          )
      ),
    );


  }
}
