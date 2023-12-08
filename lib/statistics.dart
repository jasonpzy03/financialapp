import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice_1/homepage.dart';
import '../db/budgetexpense.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {

  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {

  late SharedPreferences prefs;

  DateTime currentDate = DateTime.now();

  late int selectedMonth = currentDate.month;
  late int selectedYear = currentDate.year;

  bool isLoading = false;

  String transactType = "Expense";

  late List<Map<String, dynamic>> resultList;

  double totalAmount = 0;

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  void dispose() {
    BudgetExpenseDatabase.instance.close();

    super.dispose();
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    totalAmount = 0;
    resultList = (await BudgetExpenseDatabase.instance.getTransactionCategorySum(transactType, selectedMonth.toString(), selectedYear.toString())) ?? [];

    for (int i = 0; i < resultList.length; i++) {
      totalAmount += resultList[i]['totalAmount'];
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

  List<PieChartSectionData> generatePieChartSection() {
    List<PieChartSectionData> sections  = [];

    List<Color> sectionColors = [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.red.shade300,
      Colors.amber.shade300,
      Colors.pink.shade300,
      Colors.purple.shade300,
      Colors.orange.shade300,
    ];

    for (int i = 0; i < resultList.length; i++) {
      sections.add(
        PieChartSectionData(
          titlePositionPercentageOffset: 2.0,
          titleStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          title: resultList[i]['category'] + "\n" + ((resultList[i]['totalAmount'] / totalAmount) * 100).toStringAsFixed(0) + " %",
          value: resultList[i]['totalAmount'],
          color: sectionColors[i % sectionColors.length],
        ),
      );
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            Navigator.pop(context);
                          }
                      ),
                      SizedBox(
                          width: 10
                      ),
                      Text("Statistics",
                          style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:30, fontWeight: FontWeight.bold)),
                    ],
                  ),
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

                      getData();
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

                      getData();
                    });
                  }, icon: Icon(Icons.keyboard_arrow_right_sharp, color: Color.fromRGBO(1, 58, 85, 1), size: 30,)),
                ],
              ),
            ),
            SizedBox(
              height: 10
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        transactType = "Income";
                        getData();
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (transactType == "Income" ? Color.fromRGBO(1, 58, 85, 1) : Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.shade50,
                              offset: Offset(0.0, 5.0),
                              blurRadius: 5.0,),
                          ],
                        ),
                        child:
                        Text("Income", style: TextStyle(color: (transactType == "Income" ? Colors.white : Color.fromRGBO(1, 58, 85, 1)), fontSize:16, fontWeight: FontWeight.bold))
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        transactType = "Expense";
                        getData();
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (transactType == "Expense" ? Color.fromRGBO(1, 58, 85, 1) : Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.shade50,
                              offset: Offset(0.0, 5.0),
                              blurRadius: 5.0,),
                          ],
                        ),
                        child:
                        Text("Expense", style: TextStyle(color: (transactType == "Expense" ? Colors.white : Color.fromRGBO(1, 58, 85, 1)), fontSize:16, fontWeight: FontWeight.bold))
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text((transactType == "Expense" ? "Total Expense" : "Total Income") + "\n\$ " + totalAmount.toStringAsFixed(2), style: TextStyle(color: Colors.black, fontSize:15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    PieChart(
                      PieChartData(
                          sections: generatePieChartSection()
                      )
                    ),
                  ]
                ),
              ),
            )
          ]
      ),
    );
  }
}
