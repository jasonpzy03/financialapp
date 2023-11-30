import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/budgetexpense.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import 'homepage.dart';
import 'model/account.dart';

class CategoryDataPage extends StatefulWidget {
  final String transactType;
  final bool isDelete;
  const CategoryDataPage({required this.isDelete, required this.transactType, super.key});

  @override
  _CategoryDataPageState createState() => _CategoryDataPageState();
}

class _CategoryDataPageState extends State<CategoryDataPage> {

  TextEditingController _name = TextEditingController();

  late SharedPreferences prefs;

  late List<String> expenseCategories;
  late List<String> incomeCategories;

  late String transactType;

  late bool isDelete;
  bool isVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    initPrefs();

    transactType = widget.transactType;
    isDelete = widget.isDelete;
  }

  Future initPrefs() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    expenseCategories = prefs.getStringList('expenseCategories') ?? [];
    incomeCategories = prefs.getStringList('incomeCategories') ?? [];
    setState(() {
      isLoading = false;
    });
  }
  List<Widget> selections = [];
  Widget generateSelections() {

    selections.clear();
    List<String> selectedCategory = expenseCategories;
    if (transactType == "Income") {
      selectedCategory = incomeCategories;
    }

      for (int i = 0; i < selectedCategory.length; i++) {
        selections.add(
          GestureDetector(
            onTap: () {
              setState(() {
                _name.text = selectedCategory[i];
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
                  child: Text(selectedCategory[i],
                      style: TextStyle(color: Colors.white, fontSize:15)),
                )
            ),
          ),
        );
      }
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
    // Return the list of widgets


  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: const CircularProgressIndicator()) : Scaffold(
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
                  Text((isDelete == true ? "Delete Category" : transactType == "Expense" ? "Expense Category" : "Income Category"),
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
                        readOnly: (isDelete ? true: false),
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
                        onTap: () {
                          setState(() {
                            isVisible = true;
                          });
                        }
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
                    if (isDelete) {
                      if (transactType == "Expense") {
                        expenseCategories.remove(_name.text);
                        await prefs.setStringList('expenseCategories', expenseCategories);
                      } else {
                        incomeCategories.remove(_name.text);
                        await prefs.setStringList('incomeCategories', incomeCategories);
                      }
                    } else {
                      if (transactType == "Expense") {
                        expenseCategories.add(_name.text);
                        await prefs.setStringList('expenseCategories', expenseCategories);
                      } else {
                        incomeCategories.add(_name.text);
                        await prefs.setStringList('incomeCategories', incomeCategories);
                      }
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
                    child: Text((isDelete ? "Delete" : "Add"),
                      style: TextStyle(color: Colors.white, fontSize:20), textAlign: TextAlign.center,)
                ),
              ),
            ),
            isDelete ? Visibility(
              visible: isVisible,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Category",
                          style: TextStyle(color: Colors.black, fontSize:15)),
                          IconButton(iconSize: 20, onPressed: () {
                              setState(() {
                                isVisible = false;
                              });
                              }, icon: Icon(Icons.close))
                          ],)
                  ),
                ],
              ),
            ) : SizedBox(),
            Visibility(
                visible: isVisible,
                child: generateSelections()
            )
          ]
      ),
    );
  }
}


