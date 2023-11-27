import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_practice_1/editTransactionPage.dart';
import 'package:ui_practice_1/transactionspage.dart';
import '../homepage.dart';
import '../transactionData.dart';
import 'package:page_transition/page_transition.dart';

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
          default:
            return null;
        }
      },
    );
  }

}
