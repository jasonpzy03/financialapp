import 'package:flutter/material.dart';
import '../accounts.dart';
import 'package:ui_practice_1/db/budgetexpense.dart';
import 'package:ui_practice_1/editTransactionPage.dart';
import 'package:ui_practice_1/model/transaction.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {

  bool isLoading = false;

  DateTime currentDate = DateTime.now();

  late double inflow;
  late double outflow;

  @override
  void initState() {
    super.initState();

    refreshTransactions();
  }

  @override
  void dispose() {
    BudgetExpenseDatabase.instance.close();

    super.dispose();
  }

  Future refreshTransactions() async {
    setState(() => isLoading = true);

    inflow = (await BudgetExpenseDatabase.instance.getInflow(currentDate.month.toString(), currentDate.year.toString()))? [0]['Inflow'] ?? 0.0;
    outflow = (await BudgetExpenseDatabase.instance.getOutflow(currentDate.month.toString(), currentDate.year.toString()))? [0]['Outflow'] ?? 0.0;

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: const CircularProgressIndicator()) : Padding(
      padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transactions",
                  style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
              Text("See more",
                  style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
              height:10
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
                  width: MediaQuery.sizeOf(context).width * 0.35,
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
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            height: 20,
                            child: Text("\$ " + inflow.toString(),
                                style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )

                    ],
                  )
              ),
              Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
                  width: MediaQuery.sizeOf(context).width * 0.35,
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
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            height: 20,
                            child: Text("\$ " + outflow.toString(),
                                style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    ],
                  )
              ),
            ],
          ),
          SizedBox(
              height: 40
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Accounts",
                  style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
              Text("See more",
                  style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
              height: 10
          ),
          Container(
            height: 175,
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
          SizedBox(
              height: 50
          ),
        ],
      ),
    );


  }
}
