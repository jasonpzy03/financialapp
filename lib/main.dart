import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_practice_1/morepage.dart';
import 'package:ui_practice_1/statistics.dart';
import '../homepage.dart';
import '../transactionData.dart';
import 'package:page_transition/page_transition.dart';

import 'accountData.dart';
import 'budgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //
      theme: ThemeData(
        fontFamily: GoogleFonts.josefinSans().fontFamily,
      ),  // Set to true to show the banner in debug mode
      home: HomePage(0),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageTransition(
              child: HomePage(0),
              type: PageTransitionType.topToBottom,
              settings: settings,
            );
            break;
          case '/transactionDataPage':
            return PageTransition(
              child: TransactionDataPage(),
              type: PageTransitionType.bottomToTop,
              settings: settings,
            );
            break;
          case '/accountDataPage':
            return PageTransition(
              child: AccountDataPage(),
              type: PageTransitionType.bottomToTop,
              settings: settings,
            );
            break;
          case '/budgetsPage':
            return PageTransition(
              child: BudgetsPage(),
              type: PageTransitionType.bottomToTop,
              settings: settings,
            );
            break;
          case '/statisticsPage':
            return PageTransition(
              child: StatisticsPage(),
              type: PageTransitionType.bottomToTop,
              settings: settings,
            );
            break;
          default:
            return null;
        }
      },
    );
  }

}
