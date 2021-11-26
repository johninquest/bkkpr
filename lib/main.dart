import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rba/pages/home.dart';
import 'package:rba/styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData myTheme = ThemeData();
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: myTheme.copyWith(
        colorScheme: myTheme.colorScheme.copyWith(primary: myBlue, secondary: myBlue,),
      ),
      /* theme: ThemeData(
        primaryColor: myBlue,
        //accentColor: myBlue,
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ), */
      home: HomePage(),
    );
  }
}
