import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice_1/homepage.dart';
import '../db/budgetexpense.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import 'package:ui_practice_1/transactionspage.dart';

import 'model/account.dart';

class AddBudgetPage extends StatefulWidget {


  const AddBudgetPage({super.key});

  @override
  _AddBudgetPageState createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {

  TextEditingController _category = TextEditingController();
  TextEditingController _amount = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();

  late List<String> categories;
  List<String> keyboard = ["1", "2", "3", "Backspace", "4", "5", "6", "", "7", "8", "9", "", "", "0", ".", "Done"];
  List<Widget> selections = [];

  late SharedPreferences prefs;
  bool isVisible = false;
  String selecting = "";


  @override
  void initState() {
    super.initState();

    initPrefs();
  }
  bool isLoading = false;

  @override
  void dispose() {
    BudgetExpenseDatabase.instance.close();

    super.dispose();
  }

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    categories = prefs.getStringList('expenseCategories') ?? [];
  }

  Widget generateSelections() {
    selections.clear();

    if (selecting == "Category") {
      for (int i = 0; i < categories.length; i++) {
        selections.add(
          GestureDetector(
            onTap: () {
              setState(() {
                _category.text = categories[i];
                selecting = "Amount";
                FocusScope.of(context).requestFocus(_secondFocusNode);
              });
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.33,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(35, 38, 51, 1.0),
                  border: Border.all(
                    color: Colors.white10, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child:
                Center(
                  child: Text(categories[i],
                      style: TextStyle(color: Colors.white, fontSize:15)),
                )
            ),
          ),
        );
      }
    } else if (selecting == "Amount") {
      for (int i = 0; i < keyboard.length; i++) {
        selections.add(
          GestureDetector(
            onTap: () {
              setState(() {
                if (keyboard[i] == "Backspace") {
                  _amount.text = _amount.text.substring(0, _amount.text.length - 1);
                } else if (keyboard[i] == "Done") {
                  if (!_amount.text.contains('.')) {

                    _amount.text = _amount.text + ".00";

                  } else if ((_amount.text.split('.')[1]?.length ?? 0) < 2) {
                    if ((_amount.text.split('.')[1]?.length ?? 0) == 0)
                      _amount.text = _amount.text + "00";
                    else
                      _amount.text = _amount.text + "0";
                  }
                  isVisible = false;
                } else if (keyboard[i] == "") {
                } else {
                  if (!_amount.text.contains('.') || (_amount.text.split('.')[1]?.length ?? 0) < 2) {
                    _amount.text = _amount.text + keyboard[i];
                  }
                }

              });
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: 50,
                decoration: BoxDecoration(
                  color: (keyboard[i] == "" ? Colors.white10 : keyboard[i] == "Done" ? Colors.blue : Color.fromRGBO(35, 38, 51, 1.0)),
                  border: Border.all(
                    color: Colors.white10, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child:
                Center(
                  child: (keyboard[i] == "Backspace" ? Icon(Icons.backspace, color: Colors.white,) :  Text(keyboard[i],
                      style: TextStyle(color: Colors.white,  fontSize: (keyboard[i] == "Done" ? 20 : 25)))),
                )
            ),
          ),
        );
      }
    }

    // Return the list of widgets
    return Expanded(
      child: ListView(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [Wrap(

              children: selections
          ),]
      ),
    );
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
                        Navigator.pushNamed(context,'/budgetsPage');
                      }
                  ),
                  SizedBox(
                      width: 10
                  ),
                  Text("Update Budget",
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
                    Text("Category",
                        style: TextStyle(color: Colors.white60, fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                        controller: _category,
                        focusNode: _firstFocusNode,
                        cursorColor: Colors.white,
                        readOnly: true,
                        style: TextStyle(color: Colors.white, fontSize:15),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white10,
                                width: 2.0),),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0),),
                        ),
                        onTap: () async {
                          setState(() {
                            isVisible = true;
                            selecting = "Category";
                          });
                        }
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child:
                    Text("Amount",
                        style: TextStyle(color: Colors.white60, fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                        controller: _amount,
                        focusNode: _secondFocusNode,
                        cursorColor: Colors.white,
                        readOnly: true,
                        style: TextStyle(color: Colors.white, fontSize:15),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white10,
                                width: 2.0),),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0),),
                        ),
                        onTap: () async {
                          setState(() {
                            isVisible = true;
                            selecting = "Amount";

                          });
                        }
                    ),
                  ),
               ]
              ),
            ),
            SizedBox(
                height: 40
            ),
            GestureDetector(
              onTap: () {
                if (_category.text != "" && _amount.text != "") {
                  prefs.setString(_category.text, _amount.text);
                }

                Navigator.pushNamed(context,'/budgetsPage');
              },
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                  ),
                  child: Text("Update",
                    style: TextStyle(color: Colors.white, fontSize:20), textAlign: TextAlign.center,)
              ),
            ),
            SizedBox(
                height: 40
            ),
            Visibility(
              visible: isVisible,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selecting,
                              style: TextStyle(color: Colors.black, fontSize:15)),
                          IconButton(iconSize: 20, onPressed: () {
                            setState(() {
                              isVisible = false;
                            });
                          }, icon: Icon(Icons.close))
                        ],
                      )
                  ),
                ],
              ),
            ),
            Visibility(
                visible: isVisible,
                child: generateSelections()
            )
        ]
      ),
    );
  }
}
