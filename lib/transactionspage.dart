import 'package:flutter/material.dart';
import 'package:ui_practice_1/budgets.dart';
import 'package:ui_practice_1/db/budgetexpense.dart';
import 'package:ui_practice_1/editTransactionPage.dart';
import 'package:ui_practice_1/model/transaction.dart';
import '../transactionsBox.dart';
import 'homepage.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late List<TransactionData> transactions;
  bool isLoading = false;

  DateTime currentDate = DateTime.now();

  late int selectedMonth = currentDate.month;
  late int selectedYear = currentDate.year;
  late double inflow;
  late double outflow;
  late double cashflow;

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

    transactions = await BudgetExpenseDatabase.instance.readAllTransactions(selectedMonth.toString(), selectedYear.toString());
    inflow = (await BudgetExpenseDatabase.instance.getInflow(selectedMonth.toString(), selectedYear.toString()))? [0]['Inflow'] ?? 0.0;
    outflow = (await BudgetExpenseDatabase.instance.getOutflow(selectedMonth.toString(), selectedYear.toString()))? [0]['Outflow'] ?? 0.0;

    cashflow = inflow - outflow;
    setState(() => isLoading = false);
  }

  String monthIntToString(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Invalid Month';
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: const CircularProgressIndicator()) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Container(
                  child: Row(
                    children: [
                      Text("\$", style: TextStyle(color: Colors.white, fontSize:25, fontWeight: FontWeight.bold)),
                      SizedBox(
                          width:10
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        height: 50,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Container(
                            child: Text(cashflow.toStringAsFixed(2),
                                style: TextStyle(color: Colors.white, fontSize:45, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )

        ),
        SizedBox(
            height: 15
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
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.2,
                              height: 20,
                              child: Text("\$ " + inflow.toStringAsFixed(2),
                                  style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                            ),
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
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Container(
                                child: Text("\$ " + outflow.toStringAsFixed(2),
                                    style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
              ),
            ],
          ),
        SizedBox(
          height: 20
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () {
              setState(() {
                selectedMonth -=1;
                if (selectedMonth <= 0) {
                  selectedMonth = 12;
                  selectedYear -= 1;
                }

                refreshTransactions();
              });

            }, icon: Icon(Icons.keyboard_arrow_left_sharp, color: Colors.white, size: 20,)),
            Text(monthIntToString(selectedMonth) + " " + selectedYear.toString(),
              style: TextStyle(color: Colors.white, fontSize:25, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            IconButton(onPressed: () {
              setState(() {
                selectedMonth +=1;
                if (selectedMonth > 12) {
                  selectedMonth = 1;
                  selectedYear += 1;
                }

                refreshTransactions();
              });
            }, icon: Icon(Icons.keyboard_arrow_right_sharp, color: Colors.white, size: 20,)),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Budgets",
                  style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context,'/budgetsPage');
                },
                child: Text("See more",
                    style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        SizedBox(
            height: 20
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: transactions.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => TransactionEditPage(transaction: transaction),
                      ));
                    });
                  },
                    child: TransactionBox(transaction: transaction)
                );
              }
            ),
          ),
        ),

      ],
    );


  }
}