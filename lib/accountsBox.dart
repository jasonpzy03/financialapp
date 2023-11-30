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
            borderRadius: BorderRadius.circular(15),
            color: amount < 0 ? Colors.red.shade300 : Colors.blue,
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
                    style: TextStyle(color: Colors.white, fontSize:25, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                  height:15
              ),
              Text("Total Balance: ",
                  style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.bold)),
              SizedBox(
                  height:20
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  child: Row(
                    children: [
                      Text("\$ ",
                          style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                      Text(amount.toStringAsFixed(2),
                          style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );


  }
}
