import 'package:flutter/material.dart';
import 'package:ldgr/pages/inputs/revenue.dart'; 
import 'package:ldgr/styles/colors.dart';
import 'package:ldgr/services/router.dart';
import 'package:ldgr/pages/inputs/expense.dart';
// import 'package:rba/pages/inputs/income.dart';
import 'package:ldgr/shared/side_menu.dart';
import 'package:ldgr/shared/bottom_nav_bar.dart';
import 'inputs/income.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ldgr', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 3.0, color: Colors.white,),), 
        centerTitle: true, 
      ),
      drawer: SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 25.0), 
              child: Text('ENTER', style: TextStyle(fontSize: 20.0, color: myBlue, fontWeight: FontWeight.bold),),),
          Container(
            height: 80.0, 
            width: 200.0, 
            margin: EdgeInsets.only(bottom: 25.0),
            child: ElevatedButton(
              onPressed: () => PageRouter().navigateToPage(InputExpenditurePage(), context), 
              child: Text('EXPENSE', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),), 
              style: ElevatedButton.styleFrom(primary: myRed),),), 
         /* Container(
             height: 80.0, 
             width: 200.0, 
             margin: EdgeInsets.only(bottom: 25.0),
            child: ElevatedButton(
              onPressed: () => PageRouter().navigateToPage(InputIncomePage(), context), 
              child: Text('INCOME', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(primary: myGreen)),), */
          Container(
             height: 80.0, 
             width: 200.0, 
             margin: EdgeInsets.only(bottom: 25.0),
            child: ElevatedButton(
              onPressed: () => PageRouter().navigateToPage(InputRevenuePage(), context), 
              child: Text('INCOME', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(primary: myTeal)),),    

          ],
        ),
        ),
      bottomNavigationBar: BottomNavBar(), 
    );
  }
}
