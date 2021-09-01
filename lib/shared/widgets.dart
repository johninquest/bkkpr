import 'package:flutter/material.dart';
import 'package:tba/styles/style.dart';
import 'package:tba/services/formatter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ErrorOccured extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text(
        'Ein Fehler ist aufgetreten.',
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    ));
  }
}

class WaitingForResponse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class NoErrorOccured extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text(
        'Alles ist gut.',
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    ));
  }
}

class SideButtomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      children: [
        SpeedDialChild(
            labelWidget: MyLabelWidget('Expenditure', Colors.redAccent),
            // onTap: () => PageRouter().navigateToPage(InputExpenditurePage(), context),
            onTap: () => print('Pressed expenses button!')),
        SpeedDialChild(
            labelWidget: MyLabelWidget('Income', Colors.greenAccent),
            onTap: () => print('Pressed income button!')
            // onTap: () => PageRouter().navigateToPage(InputIncomePage(), context),
            ),
      ],
    );
  }
}

class MyLabelWidget extends StatelessWidget {
  final String myLabelName;
  final Color myLabelBackgroundColor;
  MyLabelWidget(this.myLabelName, this.myLabelBackgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Text(
        myLabelName,
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.0),
      ),
      decoration: BoxDecoration(
          color: myLabelBackgroundColor,
          borderRadius: BorderRadius.circular(5.0)),
    );
  }
}


class ListTitle extends StatelessWidget {
  // const ListTitle({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      height: 40.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('DATE', style: ListTitleStyle,),
        Text('CATEGORY', style: ListTitleStyle,),
        Text('SOURCE', style: ListTitleStyle,),
        Text('AMOUNT', style: ListTitleStyle,),
      ]),
    );
  }
}

class ListItem extends StatelessWidget {
  final String dateData;
  final String categoryData;
  final String sourceData; 
  final String amountData;
  ListItem(this.dateData, this.categoryData, this.sourceData, this.amountData);

  // const ListTitle({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
        Text(Formatter().dbToUiDate(dateData)),
        Text(Formatter().dbToUiValue(categoryData)),
        Text(Formatter().dbToUiValue(sourceData)),
        Text('$amountData'),
      ]),
    );
  }
}