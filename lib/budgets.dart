import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice_1/homepage.dart';
import '../db/budgetexpense.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import 'package:ui_practice_1/transactionspage.dart';

import 'addBudgetPage.dart';
import 'model/account.dart';

class BudgetsPage extends StatefulWidget {

  const BudgetsPage({super.key});

  @override
  _BudgetsPageState createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {

  late SharedPreferences prefs;
  List<MapEntry<String, String?>> budgets = [];
  late List<String> categories;

  List<MapEntry<String, double>> totalExpense = [];

  DateTime currentDate = DateTime.now();

  late int selectedMonth = currentDate.month;
  late int selectedYear = currentDate.year;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getBudgets();
  }

  @override
  void dispose() {
    BudgetExpenseDatabase.instance.close();

    super.dispose();
  }

  Future getBudgets() async {
    setState(() {
      isLoading = true;
    });

    budgets = [];
    totalExpense = [];

    prefs = await SharedPreferences.getInstance();
    categories = prefs.getStringList('expenseCategories') ?? [];

    for (int i = 0; i < categories.length; i++) {
      if (prefs.getString(categories[i]) != null) {
        double expense = (await BudgetExpenseDatabase.instance.getExpense(categories[i], selectedMonth.toString(), selectedYear.toString())) ? [0]['totalExpense'] ?? 0.0;

        budgets.add(MapEntry(categories[i], prefs.getString(categories[i])));
        totalExpense.add(MapEntry(categories[i], expense));
      }
    }

    setState(() {
      isLoading = false;
    });

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
    return isLoading ? Center(child: const CircularProgressIndicator()) : Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(246, 247, 252, 1),
      body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(1, 58, 85, 1), size: 30),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(1)));
                          }
                      ),
                      SizedBox(
                          width: 10
                      ),
                      Text("Budgets",
                          style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:30, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  Container(
                    child: IconButton(onPressed: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddBudgetPage("", ""),
                        ));
                      });
                    }, icon: Icon(Icons.add_alert, color: Color.fromRGBO(1, 58, 85, 1),)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {
                    setState(() {
                      selectedMonth -=1;
                      if (selectedMonth <= 0) {
                        selectedMonth = 12;
                        selectedYear -= 1;
                      }

                      getBudgets();
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

                      getBudgets();
                    });
                  }, icon: Icon(Icons.keyboard_arrow_right_sharp, color: Color.fromRGBO(1, 58, 85, 1), size: 30,)),
                ],
              ),
            ),
            SizedBox(
                height: 10
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AddBudgetPage(budgets[index].key, budgets[index].value ?? "0"),
                            ));
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(20.0),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 80,
                                  child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(budgets[index].key,
                                            style: TextStyle(color: Colors.black, fontSize:15, fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                          height: 10
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text("RM " + (budgets[index].value ?? "0"),
                                            style: TextStyle(color: Colors.black, fontSize:15, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional.centerEnd,
                                        children: [
                                          LinearProgressIndicator(
                                          value: (totalExpense[index].value / double.parse(budgets[index].value ?? "0")),
                                          minHeight: 25,
                                          borderRadius: BorderRadius.circular(15),
                                          backgroundColor: Color.fromRGBO(246, 247, 252, 1),
                                          valueColor: ((totalExpense[index].value / double.parse(budgets[index].value ?? "0")) >= 1 ? AlwaysStoppedAnimation<Color>(Color.fromRGBO(250, 69, 110, 1)) : AlwaysStoppedAnimation<Color>(Color.fromRGBO(4, 207, 164, 1))),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 100,
                                              child: Text(((totalExpense[index].value / double.parse(budgets[index].value ?? "0")) * 100).toStringAsFixed(2) + "%"
                                                    ,style: TextStyle(color: Colors.black, fontSize:15), textAlign: TextAlign.right,),
                                            ),
                                            SizedBox(
                                                width:20
                                            )
                                          ],
                                        ),

                                        ]
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 100,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("RM " + (totalExpense[index].value).toStringAsFixed(2)
                                                    ,style: TextStyle(color: Colors.black, fontSize:15)),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(((double.parse(budgets[index].value ?? "0") - totalExpense[index].value) < 0 ? "Excess " : "") + "\$ " + (double.parse(budgets[index].value ?? "0") - totalExpense[index].value).toStringAsFixed(2),
                                              style: TextStyle(color: Colors.black, fontSize:15)),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    );
                  }
              ),
            ),

          ]
      ),
    );
  }
}
