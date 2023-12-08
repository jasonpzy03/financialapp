import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../accountsBox.dart';
import 'package:ui_practice_1/db/budgetexpense.dart';
import 'package:ui_practice_1/editTransactionPage.dart';
import 'package:ui_practice_1/model/transaction.dart';

import 'editAcountPage.dart';
import 'homepage.dart';
import 'model/account.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {

  bool isLoading = false;

  DateTime currentDate = DateTime.now();

  late double inflow;
  late double outflow;
  late double cashflow;
  late double assets;
  late double liabilities;
  late double total;

  late List<AccountData> accounts;
  late List<String> accountGroups;

  String networth = "";
  String cashflowString = "";
  bool isHidden = false;

  @override
  void initState() {
    super.initState();

    refreshTransactions();
    initPrefs();
  }

  Future initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('expenseCategories', ["Food", "Transportation", "Entertainment", "Donation", "Sports"]);
    prefs.setStringList('incomeCategories', ["Allowance", "Salary", "Bonus", "Petty Cash", "Other"]);
  }

  @override
  void dispose() {
    BudgetExpenseDatabase.instance.close();

    super.dispose();
  }

  Future refreshTransactions() async {
    setState(() => isLoading = true);

    inflow = (await BudgetExpenseDatabase.instance.getInflow(currentDate.month.toString(), currentDate.year.toString()))? [0]['Inflow'] ?? 0.0;
    outflow = (await BudgetExpenseDatabase.instance.getOutflow(currentDate.month.toString(), currentDate.year.toString()))? [0]['Outflow'] ?? 0.0;
    assets = (await BudgetExpenseDatabase.instance.getAssets())?[0]['Assets'] ?? 0;
    liabilities = (await BudgetExpenseDatabase.instance.getLiabilities())?[0]['Liabilities'] ?? 0;
    total = assets + liabilities;

    cashflow = inflow - outflow;

    accounts = await BudgetExpenseDatabase.instance.readAllAccounts();
    accountGroups = await BudgetExpenseDatabase.instance.readAvailableGroups();
    networth = "RM " + total.toStringAsFixed(2);
    cashflowString = "RM " + cashflow.toStringAsFixed(2);
    setState(() => isLoading = false);
  }

  Widget generateGroupLists() {
    List<Widget> widgets = [];
    for (int i = 0; i < accountGroups.length; i++) {
      widgets.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(accountGroups[i],
                  style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {

                },
                child: Text("See more",
                    style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
      widgets.add(
          SizedBox(
              height: 40
          )
      );

      List<AccountData> accountWithThisGroup = [];

      for (int j = 0; j < accounts.length; j++) {

        if (accounts[j].accountGroup == accountGroups[i]) {
          accountWithThisGroup.add(accounts[j]);
        }
      }

      widgets.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: accountWithThisGroup.length,
            itemBuilder: (context, index) {
              final account = accountWithThisGroup[index];

              return GestureDetector(onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AccountEditPage(account: account),
                ));
              },
                  child: AccountBox(account: account));
            },
            physics: BouncingScrollPhysics(),
          ),
        ),
      );

      widgets.add(
          SizedBox(
              height: 200
          )
      );
    }

    return Wrap(
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: const CircularProgressIndicator()) : Stack(
      children: [Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        color: Color.fromRGBO(1, 58, 85, 1),
      ),Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Home",
                    style: TextStyle(color: Colors.white, fontSize:30, fontWeight: FontWeight.bold)),
                IconButton(onPressed: (){
                  Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => HomePage(3),
                  transitionDuration: Duration(seconds: 0),
                  ));
                }, icon: Icon(Icons.menu, color: Colors.white,))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
            child: Center(
              child: Container(
                  padding: EdgeInsets.only(top: 30.0, left: 40.0, right: 40.0),
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                      color: Colors.blueGrey.shade50,
                      offset: Offset(0.0, 10.0),
                      blurRadius: 5.0,
                      ),
                    ]
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("NET WORTH",
                            style: TextStyle(color: Colors.black, fontSize:15, fontWeight: FontWeight.bold)),
                        SizedBox(
                            height:5
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(networth,
                                    style: TextStyle(color: Colors.black, fontSize:35, fontWeight: FontWeight.bold)),
                              ),
                            ),

                            IconButton(icon: Icon(Icons.remove_red_eye_outlined, color: Color.fromRGBO(1, 58, 85, 1), size: 28), onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                                if (isHidden) {
                                  networth = "RM ****";
                                  cashflowString = "RM ****";
                                } else {
                                  networth = "RM " + total.toStringAsFixed(2);
                                  cashflowString = "RM " + cashflow.toStringAsFixed(2);
                                }

                              });
                            },)
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: (cashflow < 0 ? Color.fromRGBO(250, 69, 110, 1) : Color.fromRGBO(4, 207, 164, 1)),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(cashflowString,
                                style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                            height: 15
                        ),
                        GestureDetector(
                          onTap: () {

                            Navigator.pushNamed(context,'/statisticsPage');
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromRGBO(246, 247, 252, 1),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.query_stats, color: Color.fromRGBO(1, 58, 85, 1),),
                                SizedBox(
                                  height: 5
                                ),
                                Text("Statistics",
                                    style: TextStyle(color: Colors.grey, fontSize:15, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ]
                  )
              ),
            ),
          ),
          SizedBox(
            height: 30
          ),
          Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Your Accounts (" + accounts.length.toString() + ")",
                    style: TextStyle(color: Colors.black, fontSize:18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => HomePage(2),
                      transitionDuration: Duration(seconds: 0),
                    ));
                  },
                  child: Text("ADD NEW",
                      style: TextStyle(color: Color.fromRGBO(1, 58, 85, 1), fontSize:15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          SizedBox(
              height: 20
          ),
          accounts.isEmpty ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => HomePage(2),
                  transitionDuration: Duration(seconds: 0),
                ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                width: MediaQuery.sizeOf(context).width * 0.48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 2, // Border width
                  ),
                ),
                height: 160,
                child:
                Center(
                    child:
                    Text("+",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize:50,
                            fontWeight: FontWeight.bold)
                    )
                ),
              ),
            ),
          )
              : Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];

                return GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AccountEditPage(account: account),
                  ));
                },
                    child: AccountBox(account: account));
              },
              physics: BouncingScrollPhysics(),
            ),
          ),
        ],
      ),]
    );


  }
}
