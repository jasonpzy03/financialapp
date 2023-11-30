import 'package:flutter/material.dart';
import 'package:ui_practice_1/db/budgetexpense.dart';
import 'package:ui_practice_1/editTransactionPage.dart';
import 'package:ui_practice_1/model/transaction.dart';
import '../transactionsBox.dart';
import 'accountsBox.dart';
import 'editAcountPage.dart';
import 'model/account.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late List<AccountData> accounts;
  late List<String> accountGroups;
  bool isLoading = false;

  late double assets;
  late double liabilities;
  late double total;

  @override
  void initState() {
    super.initState();

    refreshTransactions();
  }

  @override
  void dispose() {
    BudgetExpenseDatabase.instance.close();

    super.dispose();
  }

  Future refreshTransactions() async {
    setState(() => isLoading = true);

    accounts = await BudgetExpenseDatabase.instance.readAllAccounts();
    accountGroups = await BudgetExpenseDatabase.instance.readAvailableGroups();
    assets = (await BudgetExpenseDatabase.instance.getAssets())?[0]['Assets'] ?? 0;
    liabilities = (await BudgetExpenseDatabase.instance.getLiabilities())?[0]['Liabilities'] ?? 0;
    total = assets + liabilities;

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
              // GestureDetector(
              //   onTap: () {
              //
              //   },
              //   child: Text("See more",
              //       style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
              //),
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
              padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Accounts",
                      style: TextStyle(color: Colors.white, fontSize:30, fontWeight: FontWeight.bold)),
                  SizedBox(
                      height: 20
                  ),
                  Text("Net Worth",
                      style: TextStyle(color: Colors.white24, fontSize:15, fontWeight: FontWeight.bold)),
                  SizedBox(
                      height:10
                  ),
                  Row(
                    children: [
                      Text("\$", style: TextStyle(color: Colors.white, fontSize:25, fontWeight: FontWeight.bold)),
                      SizedBox(
                          width:10
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        height: 50,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(total.toStringAsFixed(2),
                              style: TextStyle(color: Colors.white, fontSize:45, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              )

          ),
          SizedBox(
              height: 15
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
                        Text("Assets",
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
                                child: Text("\$ " + assets.toStringAsFixed(2),
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
                        Text("Liabilities",
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
                                child: Text("\$ " + liabilities.toStringAsFixed(2),
                                    style: TextStyle(color: Colors.white, fontSize:15, fontWeight: FontWeight.bold)),
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
              height: 20
          ),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [generateGroupLists()],
            ),
          ),
        ],
    );


  }
}