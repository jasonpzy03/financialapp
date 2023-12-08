import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice_1/categoryData.dart';
import '../db/budgetexpense.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import 'accountData.dart';
import 'homepage.dart';
import 'model/account.dart';

class TransactionDataPage extends StatefulWidget {
  const TransactionDataPage({super.key});

  @override
  _TransactionDataPageState createState() => _TransactionDataPageState();
}

class _TransactionDataPageState extends State<TransactionDataPage> {

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

  List<String> keyboard = ["1", "2", "3", "Backspace", "4", "5", "6", "", "7", "8", "9", "", "", "0", ".", "Done"];
  List<Widget> selections = [];

  bool isLoading = false;

  late List<AccountData> accounts;
  late AccountData selectedAccount;
  late AccountData fromAccount;
  late AccountData toAccount;

  late SharedPreferences prefs;

  late List<String> expenseCategories;
  late List<String> incomeCategories;

  @override
  void initState() {
    super.initState();

    getAccounts();

    initPrefs();

  }

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

    accounts = (await BudgetExpenseDatabase.instance.readAllAccounts()) ?? [];

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
      for (int i = 0; i < accounts.length; i++) {
        selections.add(
            GestureDetector(
              onTap: () {
                setState(() {
                  if (selecting == "From") {
                    _from.text = accounts[i].name;
                    fromAccount = accounts[i];
                    selecting = "To";
                    FocusScope.of(context).requestFocus(_thirdFocusNode);
                  } else if (selecting == "To" ){
                    _to.text = accounts[i].name;
                    toAccount = accounts[i];
                    selecting = "Amount";
                    FocusScope.of(context).requestFocus(_fourthFocusNode);
                  } else {
                    _account.text = accounts[i].name;
                    selectedAccount = accounts[i];
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
                      child: Text(accounts[i].name,
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isVisible = false;
                        transactType = "Transfer";
                        _account.text = "";
                        _category.text = "";
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (transactType == "Transfer" ? Color.fromRGBO(1, 58, 85, 1) : Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.shade50,
                              offset: Offset(0.0, 5.0),
                              blurRadius: 5.0,),
                          ],
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
                                cursorColor: Colors.grey.shade800,
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
                                style: TextStyle(color: Colors.grey.shade800, fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: (transactType == "Transfer" ? _from : _account),
                                focusNode: _secondFocusNode,
                                cursorColor: Colors.grey.shade800,
                                readOnly: true,
                                style: TextStyle(color: Colors.grey.shade800, fontSize:15),
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
                                style: TextStyle(color: Colors.grey.shade800, fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: (transactType == "Transfer" ? _to : _category),
                                focusNode: _thirdFocusNode,
                                cursorColor: Colors.grey.shade800,
                                readOnly: true,
                                style: TextStyle(color: Colors.grey.shade800, fontSize:15),
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
                                style: TextStyle(color: Colors.grey.shade800, fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _amount,
                                focusNode: _fourthFocusNode,
                                cursorColor: Colors.grey.shade800,
                                readOnly: true,
                                style: TextStyle(color: Colors.grey.shade800, fontSize:15),
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
                                style: TextStyle(color: Colors.grey.shade800, fontSize:15)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _note,
                                focusNode: _fifthFocusNode,
                                cursorColor: Colors.grey.shade800,
                                style: TextStyle(color: Colors.grey.shade800, fontSize:15),
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
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (transactType == "Transfer") {
                      final account1 = AccountData(
                          id: fromAccount.id,
                          accountGroup: fromAccount.accountGroup,
                          amount: fromAccount.amount - double.parse(_amount.text),
                          name: fromAccount.name,
                          description: fromAccount.description,
                      );

                      final account2 = AccountData(
                        id: toAccount.id,
                        accountGroup: toAccount.accountGroup,
                        amount: toAccount.amount + double.parse(_amount.text),
                        name: toAccount.name,
                        description: toAccount.description,
                      );

                      BudgetExpenseDatabase.instance.updateAccount(account1);
                      BudgetExpenseDatabase.instance.updateAccount(account2);

                      final transaction1 = TransactionData(
                          date: _dateTime,
                          accountId: fromAccount.id,
                          toAccountId: toAccount.id,
                          account: fromAccount.name,
                          category: "Transfer",
                          amount: double.parse(_amount.text),
                          note: fromAccount.name + " -> " + toAccount.name,
                          transactType: "Transfer");
                      BudgetExpenseDatabase.instance.createTransaction(transaction1);

                    } else {
                      final transaction = TransactionData(
                          date: _dateTime,
                          accountId: selectedAccount.id,
                          account: _account.text,
                          category: _category.text,
                          amount: double.parse(_amount.text),
                          note: _note.text,
                          transactType: transactType);
                      BudgetExpenseDatabase.instance.createTransaction(transaction);

                      double amountExpenseOrIncome = double.parse(_amount.text);

                      if (transactType == "Expense") {
                        amountExpenseOrIncome *= -1;
                      }
                      final account = AccountData(
                        id: selectedAccount.id,
                        accountGroup: selectedAccount.accountGroup,
                        amount: selectedAccount.amount + amountExpenseOrIncome,
                        name: selectedAccount.name,
                        description: selectedAccount.description,
                      );

                      BudgetExpenseDatabase.instance.updateAccount(account);
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
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(1, 58, 85, 1),
                    ),
                    child: Text("Save",
                        style: TextStyle(color: Colors.white, fontSize:20), textAlign: TextAlign.center,)
                ),
              ),
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
                                  }

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
