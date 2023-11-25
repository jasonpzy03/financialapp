import 'package:flutter/material.dart';

class Account extends StatelessWidget {

  final String accountName;
  final String balance;
  final String decimal;
  final MaterialColor bgColor;

  Account({required this.accountName, required this.balance, required this.decimal, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: bgColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 30
              ),
              Text(accountName,
                  style: TextStyle(color: Colors.white, fontSize:25, fontWeight: FontWeight.bold)),
              SizedBox(
                  height:15
              ),
              Text("Total Balance: ",
                  style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.bold)),
              SizedBox(
                  height:10
              ),
              Row(
                children: [
                  Text("\$ ",
                      style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                  Text(balance,
                      style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.bold)),
                  Text(decimal,
                      style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                ],
              )

            ],
          )
      ),
    );


  }
}
