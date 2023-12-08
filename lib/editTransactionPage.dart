import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice_1/accountData.dart';
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
    _from.text = accounts[accountId]?.name ?? "";
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
                    child: Text(selectedCategory[i],
                        style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:15, fontWeight: FontWeight.bold)),
                  )
              ),
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
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child:
                  Center(
                    child: Text(entry.value.name,
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
                  FocusScope.of(context).requestFocus(_fifthFocusNode);
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
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
        child: ListView(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            children: [Wrap(
                alignment: WrapAlignment.center,
                children: selections
            ),]
        ),
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
                  Text(transactType,
                      style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:30, fontWeight: FontWeight.bold)),
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
                        isVisible = false;
                        transactType = "Income";
                        _account.text = "";
                        _category.text = "";
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
                        isVisible = false;
                        transactType = "Expense";
                        _account.text = "";
                        _category.text = "";
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (transactType == "Expense" ? Color.fromRGBO(1, 58, 85, 1) : Colors.white),
                        ),
                        child:
                        Text("Expense", style: TextStyle(color: (transactType == "Expense" ? Colors.white : Color.fromRGBO(1, 58, 85, 1)), fontSize:16, fontWeight: FontWeight.bold))
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isVisible = false;
                        transactType = "Transfer";

                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (transactType == "Transfer" ? Color.fromRGBO(1, 58, 85, 1) : Colors.white),
                        ),
                        child:
                        Text("Transfer", style: TextStyle(color: (transactType == "Transfer" ? Colors.white : Color.fromRGBO(1, 58, 85, 1)), fontSize:16, fontWeight: FontWeight.bold))
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 255,
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
                                style: TextStyle(color: Colors.grey[800], fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _date,
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
                                style: TextStyle(color: Colors.grey[800], fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: (transactType == "Transfer" ? _from : _account),
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
                                style: TextStyle(color: Colors.grey[800], fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: (transactType == "Transfer" ? _to : _category),
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
                                style: TextStyle(color: Colors.grey[800], fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _amount,
                                focusNode: _fourthFocusNode,
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
                            Text("Note",
                                style: TextStyle(color: Colors.grey[800], fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _note,
                                focusNode: _fifthFocusNode,
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
                        height: 20
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
                height: 10
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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

                        if (transactType == "Transfer") {

                          double amountToTransfer = double.parse(_amount.text);
                          BudgetExpenseDatabase.instance.updateAccountAmount(fromAccount?.id, amountToTransfer*-1, true);
                          BudgetExpenseDatabase.instance.updateAccountAmount(toAccount?.id, amountToTransfer, true);

                          final transaction1 = TransactionData(
                              id: id,
                              date: _dateTime,
                              accountId: fromAccount?.id,
                              toAccountId: toAccount?.id,
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

                          if (transactType == "Expense") {

                            amountSpentOrReceived *= -1;
                          }

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
                height: 15
            ),
            Visibility(
              visible: isVisible,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                            Row(
                              children: [
                                selecting == "Category" ? IconButton(iconSize: 20, onPressed: () async {

                                    bool result = await Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CategoryDataPage(isDelete: true, transactType : transactType),
                                    ));

                                    if(result != null && result){
                                      setState(() {
                                        initPrefs();
                                      });
                                    }


                                }, icon: Icon(Icons.delete)) : SizedBox(),
                                selecting == "Category" || selecting == "Accounts" ? IconButton(iconSize: 20, onPressed: () async {

                                    if (selecting == "Accounts" || selecting == "From" || selecting == "To") {
                                      bool result = await Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => AccountDataPage(),
                                      ));

                                      if(result != null && result){
                                        setState(() {
                                          initPrefs();
                                          getAccounts();
                                        });
                                      };
                                    } else if (selecting == "Category") {

                                      bool result = await Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CategoryDataPage(isDelete: false, transactType : transactType),
                                      ));

                                      if(result != null && result){
                                        setState(() {
                                          initPrefs();
                                        });
                                      };
                                    };
                                }, icon: Icon(Icons.edit)) : SizedBox(),
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
