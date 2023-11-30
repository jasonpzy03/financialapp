import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'db/budgetexpense.dart';


class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
      child: Column(
        children: [
          Row(
            children: [
              Text("Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),)
            ],
          ),
          SizedBox(
            height: 20
          ),
          IconButton(onPressed: () async {
            databaseFactory.deleteDatabase(join(await getDatabasesPath(), 'budgetexpense.db'));

            SharedPreferences prefs = await SharedPreferences.getInstance();

            // Clear all key-value pairs in shared preferences
            await prefs.clear();

          }, icon: Icon(Icons.restart_alt, color: Colors.white, size: 25,)),
          Text("Reset Database", style: TextStyle(color: Colors.white),)
        ],
      ),
    );

  }

}