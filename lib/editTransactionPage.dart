import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice_1/homepage.dart';
import '../db/budgetexpense.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import 'package:ui_practice_1/transactionspage.dart';

import 'categoryData.dart';
import 'model/account.dart';

class TransactionEditPage extends StatefulWidget {

  final TransactionData? transaction;

  const TransactionEditPage({
    Key? key,
    this.transaction,
  }) : super(key: key);

  @override
  _TransactionEditPageState createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {

  TextEditingController _date = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()) + " (" + DateFormat('EEEE').format(DateTime.now()) + ")");
  DateTime _dateTime = DateTime.now();
  TextEditingController _account = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();
  TextEditingController _amount = TextEditingController();
  TextEditingController _note = TextEditingController();
  final FocusNode _firstFocusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _thirdFocusNode = FocusNode();
  final FocusNode _fourthFocusNode = FocusNode();
  final FocusNode _fifthFocusNode = FocusNode();

  String transactType = 'Expense';
  bool isVisible = false;
  String selecting = "";

  late List<String> expenseCategories;
  late List<String> incomeCategories;
  List<String> keyboard = ["1", "2", "3", "Backspace", "4", "5", "6", "", "7", "8", "9", "", "", "0", ".", "Done"];
  List<Widget> selections = [];

  Color underlineColor = Colors.red.shade300;

  late int id;
  late DateTime date;
  late int accountId;
  late int toAccountId;
  late String account;
  late String category;
  late double amount;
  late String note;
  late String _transactType;

  late Map<int?, AccountData> accounts;
  late AccountData? selectedAccount;
  late AccountData? fromAccount;
  late AccountData? toAccount;

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    id = widget.transaction?.id ?? 0;
    date = widget.transaction?.date ?? DateTime.now();
    accountId = widget.transaction?.accountId ?? 0;
    toAccountId = widget.transaction?.toAccountId ?? 0;
    account = widget.transaction?.account ?? '';
    category = widget.transaction?.category ?? '';
    amount = widget.transaction?.amount ?? 0;
    note = widget.transaction?.note ?? '';
    _transactType = widget.transaction?.transactType ?? '';

    _date.text = DateFormat('yyyy-MM-dd').format(date) + " (" + DateFormat('EEEE').format(date) + ")";
    _account.text = account;
    _category.text = category;
    _from.text = account;

    _amount.text = amount.toString();
    _note.text = note;
    transactType = _transactType;



    getAccounts();
    initPrefs();
  }
  bool isLoading = false;

  @override
  void dispose() {
    BudgetExpenseDatabase.instance.close();

    super.dispose();
  }

  Future initPrefs() async {
    setState(() => isLoading = true);
    prefs = await SharedPreferences.getInstance();
    expenseCategories = prefs.getStringList('expenseCategories') ?? [];
    incomeCategories = prefs.getStringList('incomeCategories') ?? [];
    setState(() => isLoading = false);
  }

  Future getAccounts() async {
    setState(() => isLoading = true);

    accounts = await BudgetExpenseDatabase.instance.readAllAccountsMap();
    selectedAccount = accounts[accountId];
    fromAccount = accounts[accountId];
    toAccount = accounts[toAccountId];
    _to.text = accounts[toAccountId]?.name ?? "";
    setState(() => isLoading = false);
  }

  Widget generateSelections() {
    selections.clear();
    List<String> selectedCategory = expenseCategories;
    if (transactType == "Income") {
      selectedCategory = incomeCategories;
    }
    if (selecting == "Category") {
      for (int i = 0; i < selectedCategory.length; i++) {
        selections.add(
          GestureDetector(
            onTap: () {
              setState(() {
                _category.text = selectedCategory[i];
                selecting = "Amount";
                FocusScope.of(context).requestFocus(_fourthFocusNode);
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
    } else if (selecting == "Accounts" || selecting == "From" || selecting == "To") {
      for (var entry in accounts.entries) {
        selections.add(
          GestureDetector(
            onTap: () {
              setState(() {
                if (selecting == "From") {
                  _from.text = entry.value.name;
                  fromAccount = entry.value;
                  selecting = "To";
                  FocusScope.of(context).requestFocus(_thirdFocusNode);
                } else if (selecting == "To" ){
                  _to.text = entry.value.name;
                  toAccount = entry.value;
                  FocusScope.of(context).requestFocus(_fourthFocusNode);
                } else {
                  selectedAccount = entry.value;
                  _account.text = entry.value.name;
                  selecting = "Category";
                  FocusScope.of(context).requestFocus(_thirdFocusNode);
                }

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
                  child: Text(entry.value.name,
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
                  FocusScope.of(context).requestFocus(_fifthFocusNode);
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
                  color: (keyboard[i] == "" ? Colors.white10 : (keyboard[i] == "Done" && transactType == "Income") ? Colors.blue : (keyboard[i] == "Done" && transactType == "Expense") ? Colors.red.shade300 : (keyboard[i] == "Done" && transactType == "Transfer") ? Colors.white : Color.fromRGBO(35, 38, 51, 1.0)),
                  border: Border.all(
                    color: Colors.white10, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child:
                Center(
                  child: (keyboard[i] == "Backspace" ? Icon(Icons.backspace, color: Colors.white,) :  Text(keyboard[i],
                      style: TextStyle(color: (keyboard[i] == "Done" && transactType == "Transfer" ? Colors.grey[800] : Colors.white),  fontSize: (keyboard[i] == "Done" ? 20 : 25)))),
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
                  Text(transactType,
                      style: TextStyle(color: Colors.white, fontSize:30, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
                height: 20
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        transactType = "Income";
                        _category.text = "";
                        underlineColor = Colors.blue;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: (transactType == "Income" ? Color.fromRGBO(35, 38, 51, 1.0) : Colors.black),
                          border: Border.all(
                            color: (transactType == "Income" ? Colors.blue : Colors.white10), // Border color
                            width: 1.5, // Border width
                          ),
                        ),
                        child:
                        Text("Income", style: TextStyle(color: (transactType == "Income" ? Colors.blue : Colors.white60), fontSize:15, fontWeight: FontWeight.bold))
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        transactType = "Expense";
                        _category.text = "";
                        underlineColor = Colors.red.shade300;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: (transactType == "Expense" ? Color.fromRGBO(35, 38, 51, 1.0) : Colors.black),
                          border: Border.all(
                            color: (transactType == "Expense" ? Colors.red.shade300 : Colors.white10), // Border color
                            width: 1.5, // Border width
                          ),
                        ),
                        child:
                        Text("Expense", style: TextStyle(color: (transactType == "Expense" ? Colors.red.shade300 : Colors.white60), fontSize:15, fontWeight: FontWeight.bold))
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        transactType = "Transfer";
                        underlineColor = Colors.white;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: (transactType == "Transfer" ? Color.fromRGBO(35, 38, 51, 1.0) : Colors.black),
                          border: Border.all(
                            color: (transactType == "Transfer" ? Colors.white : Colors.white10), // Border color
                            width: 1.5, // Border width
                          ),
                        ),
                        child:
                        Text("Transfer", style: TextStyle(color: (transactType == "Transfer" ? Colors.white : Colors.white60), fontSize:15, fontWeight: FontWeight.bold))
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 200,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            child:
                            Text("Date",
                                style: TextStyle(color: Colors.white60, fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _date,
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
                                        color: underlineColor,
                                        width: 2.0),),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    setState(() {
                                      isVisible = false;
                                      _dateTime = pickedDate;
                                      _date.text = DateFormat('yyyy-MM-dd').format(pickedDate) + " (" + DateFormat('EEEE').format(pickedDate) + ")";
                                      FocusScope.of(context).requestFocus(_secondFocusNode);
                                    });
                                  }
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
                            Text((transactType == "Transfer" ? "From" : "Account"),
                                style: TextStyle(color: Colors.white60, fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: (transactType == "Transfer" ? _from : _account),
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
                                        color: underlineColor,
                                        width: 2.0),),
                                ),
                                onTap: () async {
                                  setState(() {
                                    isVisible = true;
                                    if (transactType == "Transfer") {
                                      selecting = "From";
                                    } else {
                                      selecting = "Accounts";
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
                            Text((transactType == "Transfer" ? "To" : "Category"),
                                style: TextStyle(color: Colors.white60, fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: (transactType == "Transfer" ? _to : _category),
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
                                        color: underlineColor,
                                        width: 2.0),),
                                ),
                                onTap: () async {
                                  setState(() {
                                    isVisible = true;
                                    if (transactType == "Transfer") {
                                      selecting = "To";
                                    } else {
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
                                style: TextStyle(color: Colors.white60, fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _amount,
                                focusNode: _fourthFocusNode,
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
                                        color: underlineColor,
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
                            Text("Note",
                                style: TextStyle(color: Colors.white60, fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _note,
                                focusNode: _fifthFocusNode,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white, fontSize:15),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white10,
                                        width: 2.0),),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: underlineColor,
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
                        height: 20
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
                height: 40
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_transactType != transactType) {
                          if (_transactType == "Transfer") {
                            double amountToRestore = amount;
                            double amountToDeduct = amount * -1;
                            BudgetExpenseDatabase.instance.updateAccountAmount(accountId, amountToRestore, true);
                            BudgetExpenseDatabase.instance.updateAccountAmount(toAccountId, amountToDeduct, true);
                          } else {
                            double amountToRestore = amount;

                            if (_transactType == "Income") {
                              amountToRestore *= -1;
                            }

                            BudgetExpenseDatabase.instance.updateAccountAmount(accountId, amountToRestore, true);
                          }
                        }

                        if (transactType == "Transfer") {

                          double amountToTransfer = double.parse(_amount.text);
                          BudgetExpenseDatabase.instance.updateAccountAmount(fromAccount?.id, amountToTransfer*-1, true);
                          BudgetExpenseDatabase.instance.updateAccountAmount(toAccount?.id, amountToTransfer, true);

                          final transaction1 = TransactionData(
                              id: id,
                              date: _dateTime,
                              accountId: fromAccount?.id,
                              account: fromAccount?.accountGroup ?? "",
                              category: "Transfer",
                              amount: double.parse(_amount.text),
                              note: (fromAccount?.name ?? "") + " -> " + (toAccount?.name ?? ""),
                              transactType: "Transfer");

                          BudgetExpenseDatabase.instance.updateTransaction(transaction1);


                        } else {

                          final transaction = TransactionData(
                              id: id,
                              date: _dateTime,
                              accountId: selectedAccount?.id,
                              account: _account.text,
                              category: _category.text,
                              amount: double.parse(_amount.text),
                              note: _note.text,
                              transactType: transactType
                          );
                          BudgetExpenseDatabase.instance.updateTransaction(
                              transaction);

                          double amountSpentOrReceived = double.parse(_amount.text);
                          double amountLastTransaction = amount;

                          if (transactType == "Expense") {

                            amountSpentOrReceived *= -1;
                          }

                          if (transactType == "Income") {
                            amountLastTransaction *= -1;
                          }

                          BudgetExpenseDatabase.instance.updateAccountAmount(selectedAccount?.id, amountLastTransaction, true);
                          BudgetExpenseDatabase.instance.updateAccountAmount(selectedAccount?.id, amountSpentOrReceived, true);

                        }
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HomePage(1),
                        ));
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: underlineColor,
                        ),
                        child: Text("Update",
                          style: TextStyle(color: (transactType == "Transfer" ? Colors.black : Colors.white), fontSize:20), textAlign: TextAlign.center,)
                    ),
                  ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_transactType == "Transfer") {
                          double amountToRestore = amount;
                          double amountToDeduct = amount * -1;
                          BudgetExpenseDatabase.instance.updateAccountAmount(accountId, amountToRestore, true);
                          BudgetExpenseDatabase.instance.updateAccountAmount(toAccountId, amountToDeduct, true);
                        } else {
                          double amountToRestore = amount;

                          if (_transactType == "Income") {
                            amountToRestore *= -1;
                          }

                          BudgetExpenseDatabase.instance.updateAccountAmount(accountId, amountToRestore, true);
                        }

                        BudgetExpenseDatabase.instance.deleteTransaction(id);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HomePage(1),
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
                          Row(
                            children: [
                              selecting == "Category" ? IconButton(iconSize: 20, onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => CategoryDataPage(isDelete: true, transactType : transactType),
                                  ));
                                });
                              }, icon: Icon(Icons.delete)) : SizedBox(),
                              IconButton(iconSize: 20, onPressed: () {
                                setState(() {
                                  if (selecting == "Accounts") {
                                    Navigator.pushNamed(context, '/accountDataPage');
                                  } else if (selecting == "Category") {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => CategoryDataPage(isDelete: false, transactType : transactType),
                                    ));
                                  }
                                });
                              }, icon: Icon(Icons.edit)),
                              IconButton(iconSize: 20, onPressed: () {
                                setState(() {
                                  isVisible = false;
                                });
                              }, icon: Icon(Icons.close))
                            ],
                          ),
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
