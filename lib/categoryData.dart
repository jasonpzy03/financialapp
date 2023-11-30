import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/budgetexpense.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import 'homepage.dart';
import 'model/account.dart';

class CategoryDataPage extends StatefulWidget {
  final String transactType;
  const CategoryDataPage({required this.transactType, super.key});

  @override
  _CategoryDataPageState createState() => _CategoryDataPageState();
}

class _CategoryDataPageState extends State<CategoryDataPage> {

  TextEditingController _name = TextEditingController();

  late SharedPreferences prefs;

  late List<String> expenseCategories;
  late List<String> incomeCategories;

  late String transactType;

  @override
  void initState() {
    super.initState();

    initPrefs();

    transactType = widget.transactType;
  }

  Future initPrefs() async {
    // Obtain shared preferences.
    prefs = await SharedPreferences.getInstance();
    expenseCategories = prefs.getStringList('expenseCategories') ?? [];
    incomeCategories = prefs.getStringList('incomeCategories') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(35, 38, 51, 1.0),
      body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HomePage(1),
                        ));
                      }
                  ),
                  SizedBox(
                      width: 10
                  ),
                  Text((transactType == "Expense" ? "Expense Category" : "Income Category"),
                      style: TextStyle(color: Colors.white, fontSize:30, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
                height: 20
            ),
            Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child:
                    Text("Name",
                        style: TextStyle(color: Colors.white60, fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                        controller: _name,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize:15),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white10,
                                width: 2.0),),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0),),
                        ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: GestureDetector(
                onTap: () {
                  setState(() async {
                    if (transactType == "Expense") {
                      expenseCategories.add(_name.text);
                      await prefs.setStringList('expenseCategories', expenseCategories);
                    } else {
                      incomeCategories.add(_name.text);
                      await prefs.setStringList('incomeCategories', incomeCategories);
                    }

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HomePage(1),
                    ));
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue,
                    ),
                    child: Text("Add",
                      style: TextStyle(color: Colors.white, fontSize:20), textAlign: TextAlign.center,)
                ),
              ),
            ),
          ]
      ),
    );
  }
}


