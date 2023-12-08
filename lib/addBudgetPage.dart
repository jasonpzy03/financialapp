import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice_1/homepage.dart';
import '../db/budgetexpense.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import 'package:ui_practice_1/transactionspage.dart';

import 'model/account.dart';

class AddBudgetPage extends StatefulWidget {

  late String category;
  late String budget;

  AddBudgetPage(String category, String budget, {super.key}) {
    this.category = category;
    this.budget = budget;
  }

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
  bool isUpdate = false;
  String selecting = "";

  late String category;
  late String budget;

  @override
  void initState() {
    super.initState();

    category = widget.category;
    budget = widget.budget;

    _category.text = category;
    _amount.text = budget;

    if (category != "" && budget != "") {
      isUpdate = true;
    }

    initPrefs();
  }
  bool isLoading = false;

  @override
  void dispose() {
    BudgetExpenseDatabase.instance.close();

    super.dispose();
  }

  Future initPrefs() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    categories = prefs.getStringList('expenseCategories') ?? [];
    setState(() {
      isLoading = false;
    });
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
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.30,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),

                  ),
                  child:
                  Center(
                    child: Text(categories[i],
                        style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:15, fontWeight: FontWeight.bold)),
                  )
              ),
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
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: (keyboard[i] == "" ? Colors.white10 : keyboard[i] == "Done" ? Color.fromRGBO(1, 58, 85, 1) : Colors.white),
                  ),
                  child:
                  Center(
                    child: (keyboard[i] == "Backspace" ? Icon(Icons.backspace, color: Color.fromRGBO(1, 58, 85, 1),) :  Text(keyboard[i],
                        style: TextStyle(color: keyboard[i] == "Done" ? Colors.white : Color.fromRGBO(1, 58, 85, 1),  fontSize: (keyboard[i] == "Done" ? 20 : 25)))),
                  )
              ),
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
              alignment: WrapAlignment.center,
              children: selections
          ),]
      ),
    );
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
                  Text((isUpdate ? "Update Budget" : "Add Budget"),
                      style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:30, fontWeight: FontWeight.bold)),
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
                        style: TextStyle(color: Colors.grey[800], fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                        controller: _category,
                        focusNode: _firstFocusNode,
                        cursorColor: Colors.grey[800],
                        readOnly: true,
                        style: TextStyle(color: Colors.grey[800], fontSize:15),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(1, 58, 85, 1),
                                width: 2.0),),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0),),
                        ),
                        onTap: () async {
                          setState(() {
                            if (!isUpdate) {
                              isVisible = true;
                              selecting = "Category";
                            }
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
                        style: TextStyle(color: Colors.grey[800], fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                        controller: _amount,
                        focusNode: _secondFocusNode,
                        cursorColor: Colors.grey[800],
                        readOnly: true,
                        style: TextStyle(color: Colors.grey[800], fontSize:15),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(1, 58, 85, 1),
                                width: 2.0),),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_category.text != "" && _amount.text != "") {
                      prefs.setString(_category.text, _amount.text);
                    }

                    Navigator.pushNamed(context,'/budgetsPage');
                  },
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(1, 58, 85, 1),
                      ),
                      child: Text((isUpdate ? "Update" : "Add"),
                        style: TextStyle(color: Colors.white, fontSize:20), textAlign: TextAlign.center,)
                  ),
                ),
                SizedBox(
                  width: 20
                ),
                isUpdate ? GestureDetector(
                  onTap: () {
                    prefs.remove(_category.text);
                    Navigator.pushNamed(context,'/budgetsPage');
                  },
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                      ),
                      child: Text("Delete",
                        style: TextStyle(color: Colors.white, fontSize:20), textAlign: TextAlign.center,)
                  ),
                ) : SizedBox(
                    height: 0
                )
              ],
            ),
            SizedBox(
                height: 40
            ),
            Visibility(
              visible: isVisible,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.shade50,
                                offset: Offset(0.0, 10.0),
                                blurRadius: 5.0,),
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(selecting,
                                style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:15, fontWeight: FontWeight.bold)),
                            IconButton(iconSize: 20, onPressed: () {
                              setState(() {
                                isVisible = false;
                              });
                            }, icon: Icon(Icons.close))
                          ],
                        )
                    ),
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
