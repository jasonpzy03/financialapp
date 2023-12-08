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
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.30,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child:
                  Center(
                    child: Text(accountGroups[i],
                        style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:16, fontWeight: FontWeight.bold)),
                  )
              ),
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
    return Scaffold(
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
                  Text("Edit Account",
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
                    Text("Group",
                        style: TextStyle(color: Colors.grey[800], fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                        controller: _group,
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
                        style: TextStyle(color: Colors.grey[800], fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _name,
                      focusNode: _secondFocusNode,
                      cursorColor: Colors.grey[800],
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
                        style: TextStyle(color: Colors.grey[800], fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                        controller: _amount,
                        focusNode: _thirdFocusNode,
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
                        style: TextStyle(color: Colors.grey[800], fontSize:15)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _description,
                      focusNode: _fourthFocusNode,
                      cursorColor: Colors.grey[800],
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
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(1, 58, 85, 1),
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
                        borderRadius: BorderRadius.circular(10),
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


