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
  late double assets;
  late double liabilities;
  late double total;

  late List<AccountData> accounts;
  late List<String> accountGroups;

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

    accounts = await BudgetExpenseDatabase.instance.readAllAccounts();
    accountGroups = await BudgetExpenseDatabase.instance.readAvailableGroups();

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
    return isLoading ? Center(child: const CircularProgressIndicator()) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(top: 60.0, left: 30.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Home Summary",
                        style: TextStyle(color: Colors.white, fontSize:30, fontWeight: FontWeight.bold)),
                    SizedBox(
                        height:20
                    ),
                    Text("Net Worth",
                        style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
                    SizedBox(
                        height:10
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        child: Row(
                          children: [
                            Text("\$", style: TextStyle(color: Colors.white, fontSize:25, fontWeight: FontWeight.bold)),
                            SizedBox(
                                width:10
                            ),
                            Text(total.toStringAsFixed(2),
                                style: TextStyle(color: Colors.white, fontSize:45, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    )
                  ]
              )
          ),
          SizedBox(
              height:20
          ),
          Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Transactions",
                    style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HomePage(1),
                    ));
                  },
                  child: Text("See more",
                      style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          SizedBox(
              height:10
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(49, 54, 69, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Inflow",
                          style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
                      SizedBox(
                          height:15
                      ),
                      Row(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.2,
                              height: 20,
                              child: Text("\$ " + inflow.toStringAsFixed(2),
                                  style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )

                    ],
                  )
              ),
              Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(49, 54, 69, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Outflow",
                          style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
                      SizedBox(
                          height:15
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            height: 20,
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Container(
                                child: Text("\$ " + outflow.toStringAsFixed(2),
                                    style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
              ),
            ],
          ),
          SizedBox(
              height: 40
          ),
          Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Accounts",
                    style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomePage(2),
                      ));
                  },
                  child: Text("See more",
                      style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
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
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HomePage(2),
                ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                width: MediaQuery.sizeOf(context).width * 0.48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.white24, // Border color
                    width: 2, // Border width
                  ),
                ),
                height: 160,
                child:
                Center(
                    child:
                    Text("+",
                        style: TextStyle(
                            color: Colors.white24,
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
          SizedBox(
            height: 110
          ),
          Center(
            child: GestureDetector(
              onTap: () {

                Navigator.pushNamed(context,'/statisticsPage');
              },
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 25.0, right: 25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[800],
                  border: Border.all(
                    color: Colors.white10, // Border color
                    width: 1.5, // Border width
                  ),
                ),
                child: Text("View Statistics",
                    style: TextStyle(color: Colors.white54, fontSize:20, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
    );


  }
}
