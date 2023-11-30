import 'package:flutter/material.dart';
import '../db/budgetexpense.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import 'homepage.dart';
import 'model/account.dart';

class AccountEditPage extends StatefulWidget {
  final AccountData? account;

  const AccountEditPage({
    Key? key,
    this.account,
  }) : super(key: key);

  @override
  _AccountEditPageState createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {

  TextEditingController _group = TextEditingController(text: "Cash");
  TextEditingController _amount = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _thirdFocusNode = FocusNode();
  final FocusNode _fourthFocusNode = FocusNode();

  bool isVisible = false;
  String selecting = "Account Group";

  List<String> accountGroups = ["Cash", "Accounts", "Card", "Debit Card", "Savings", "Top-Up/Prepaid", "Investments", "Overdrafts", "Loan", "Insurance", "Others"];
  List<String> keyboard = ["1", "2", "3", "Backspace", "4", "5", "6", "-", "7", "8", "9", "", "", "0", ".", "Done"];
  List<Widget> selections = [];

  late int id;
  late String accountGroup;
  late String name;
  late double amount;
  late String description;

  @override
  void initState() {
    super.initState();

    id = widget.account?.id ?? 0;
    accountGroup = widget.account?.accountGroup ?? '';
    name = widget.account?.name ?? '';
    amount = widget.account?.amount ?? 0;
    description = widget.account?.description ?? '';

    _group.text = accountGroup;
    _name.text = name;
    _amount.text = amount.toString();
    _description.text = description;

  }

  Widget generateSelections() {

    selections.clear();
    if (selecting == "Account Group") {
      for (int i = 0; i < accountGroups.length; i++) {
        selections.add(
          GestureDetector(
            onTap: () {
              setState(() {
                _group.text = accountGroups[i];
                isVisible = false;
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
                  child: Text(accountGroups[i],
                      style: TextStyle(color: Colors.white, fontSize:15)),
                )
            ),
          ),
        );
      }
    } else if(selecting == "Amount") {
      for (int i = 0; i < keyboard.length; i++) {
        selections.add(
          GestureDetector(
            onTap: () {
              setState(() {
                if (keyboard[i] == "Backspace") {
                  _amount.text =
                      _amount.text.substring(0, _amount.text.length - 1);
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
                  FocusScope.of(context).requestFocus(_fourthFocusNode);
                } else if (keyboard[i] == "") {
                  //Do nothing
                }
                else if (keyboard[i] == "-") {
                  if (_amount.text[0] == "-") {
                    _amount.text = _amount.text.substring(1);
                  } else {
                    _amount.text = "-" + _amount.text;
                  }

                } else {
                  if (!_amount.text.contains('.') ||
                      (_amount.text.split('.')[1]?.length ?? 0) < 2) {
                    _amount.text = _amount.text + keyboard[i];
                  }
                }
              });
            },
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.25,
                height: 50,
                decoration: BoxDecoration(
                  color: keyboard[i] == "" ? Colors.white10 : Color.fromRGBO(35, 38, 51, 1.0),
                  border: Border.all(
                    color: Colors.white10, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child:
                Center(
                  child: (keyboard[i] == "Backspace" ? Icon(
                    Icons.backspace, color: Colors.white,) : Text(keyboard[i],
                      style: TextStyle(color: Colors.white,
                          fontSize: (keyboard[i] == "Done" ? 20 : 25)))),
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
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HomePage(2),
                        ));
                      }
                  ),
                  SizedBox(
                      width: 10
                  ),
                  Text("Edit Account",
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
                    Text("Group",
                        style: TextStyle(color: Colors.white60, fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                        controller: _group,
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
                                color: Colors.blue,
                                width: 2.0),),
                        ),
                        onTap: () async {
                          setState(() {
                            isVisible = true;
                            selecting = "Account Group";
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
                    Text("Name",
                        style: TextStyle(color: Colors.white60, fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _name,
                      focusNode: _secondFocusNode,
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
                      onTap: () async {
                        setState(() {
                          isVisible = false;
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
                        focusNode: _thirdFocusNode,
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
                                color: Colors.blue,
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
                    Text("Description",
                        style: TextStyle(color: Colors.white60, fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _description,
                      focusNode: _fourthFocusNode,
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
                      onTap: () async {
                        setState(() {
                          isVisible = false;
                        });
                      }
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      final account = AccountData(
                          id: id,
                          accountGroup: _group.text,
                          name: _name.text,
                          amount: double.parse(_amount.text),
                          description: _description.text
                      );
                      BudgetExpenseDatabase.instance.updateAccount(account);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomePage(2),
                      ));
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue,
                      ),
                      child: Text("Update",
                        style: TextStyle(color: Colors.white, fontSize:20), textAlign: TextAlign.center,)
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      BudgetExpenseDatabase.instance.deleteAccount(id);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomePage(2),
                      ));
                    });
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
                ),
              ],
            ),
            SizedBox(
              height: 30
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


