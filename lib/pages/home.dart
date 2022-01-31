import 'package:flutter/material.dart';
import 'package:ldgr/shared/dialogs.dart';
import 'package:ldgr/styles/colors.dart';
import 'package:ldgr/services/router.dart';
import 'package:ldgr/pages/inputs/expense.dart';
import 'package:ldgr/shared/side_menu.dart';
import 'package:ldgr/shared/bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseAuthService().checkAuthStatus();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ldgr',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            child: IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => LogoutDialog(),
                  barrierDismissible: true),
              icon: Icon(Icons.logout_outlined),
              tooltip: 'Log out',
            ),
          )
        ],
      ),
      drawer: SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 25.0),
              child: Text(
                'ENTER',
                style: TextStyle(
                    fontSize: 20.0, color: myBlue, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 60.0,
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.only(bottom: 25.0),
              child: ElevatedButton(
                onPressed: () => PageRouter()
                    .navigateToPage(InputExpenditurePage(), context),
                child: Text(
                  'EXPENSE',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(primary: myRed),
              ),
            ),
            Container(
              height: 60.0,
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.only(bottom: 25.0),
              child: ElevatedButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => InfoDialog('Coming soon!')),
                  child: Text('INCOME',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(primary: myTeal)),
            ),
            Container(
              height: 60.0,
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.only(bottom: 25.0),
              child: ElevatedButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => InfoDialog('Coming soon!'),
                      barrierDismissible: true),
                  child: Text('STOCK',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(primary: myBlue)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
