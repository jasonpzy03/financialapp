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

            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Transactions",
                          style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:30, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: (){
                        Navigator.push(context, PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => HomePage(3),
                          transitionDuration: Duration(seconds: 0),
                        ));
                      }, icon: Icon(Icons.menu, color: Color.fromRGBO(1, 58, 85, 1),))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children : [
                          IconButton(onPressed: () {
                            setState(() {
                              selectedMonth -=1;
                              if (selectedMonth <= 0) {
                                selectedMonth = 12;
                                selectedYear -= 1;
                              }

                              refreshTransactions();
                            });

                          }, icon: Icon(Icons.keyboard_arrow_left_sharp, color: Color.fromRGBO(1, 58, 85, 1), size: 30,)),
                          Text(monthIntToString(selectedMonth) + " " + selectedYear.toString(),
                            style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:25, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          IconButton(onPressed: () {
                            setState(() {
                              selectedMonth +=1;
                              if (selectedMonth > 12) {
                                selectedMonth = 1;
                                selectedYear += 1;
                              }

                              refreshTransactions();
                            });
                          }, icon: Icon(Icons.keyboard_arrow_right_sharp, color: Color.fromRGBO(1, 58, 85, 1), size: 30,)),
                        ]
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context,'/budgetsPage');
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 25.0, right: 25.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey.shade50,

                                  blurRadius: 5.0,
                                ),
                              ]
                          ),
                          child: Text("Budgets",
                              style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height:20
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("Cashflow",
                              style: TextStyle(color: Colors.grey[800], fontSize:15, fontWeight: FontWeight.bold)),
                          SizedBox(
                              height: 5
                          ),
                          Container(
                            width: 100,
                            child: FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              child: Text("RM " + cashflow.toStringAsFixed(2),
                                    style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:15, fontWeight: FontWeight.bold)),

                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Inflow",
                              style: TextStyle(color: Colors.grey[800], fontSize:15, fontWeight: FontWeight.bold)),
                          SizedBox(
                              height: 5
                          ),
                          Container(
                            width: 100,
                            child: FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              child: Text("RM " + inflow.toStringAsFixed(2),
                                  style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:15, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Outflow",
                              style: TextStyle(color: Colors.grey[800], fontSize:15, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5
                          ),
                          Container(
                            width: 100,
                            child: FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              child: Text("RM " + outflow.toStringAsFixed(2),
                                    style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:15, fontWeight: FontWeight.bold)),

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  height: 15,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(

                        color: Colors.blueGrey.shade200, // Border color
                        width: 1, // Bo// Border width
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),

        SizedBox(
            height: 20
        ),
        transactions.isEmpty ? Expanded(child: Center(child: Text("No transactions",
            style: TextStyle(color: Colors.grey, fontSize:18, fontWeight: FontWeight.bold)),)) : Expanded(
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