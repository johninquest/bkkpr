import 'package:flutter/material.dart';
import 'package:ldgr/firebase/firestore.dart';
import 'package:ldgr/pages/stock/add_to_stock.dart';
import 'package:ldgr/services/router.dart';
import 'package:ldgr/shared/bottom_nav_bar.dart';
import 'package:ldgr/shared/widgets.dart';
import 'package:ldgr/styles/colors.dart';

class StockOverviewPage extends StatelessWidget {
  const StockOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _fsQuery = FirestoreService().getSubCollection('records', 'stock');
    return Scaffold(
      appBar: AppBar(
        title: Text('Items in stock'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _fsQuery,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorOccured();
            }
            if (snapshot.hasData) {
              List resData = snapshot.data as List;
              return StockOverviewData(stockData: resData);
            } else {
              return WaitingForResponse();
            }
          }),
/*       floatingActionButton: Container(
          decoration: BoxDecoration(
              color: myBlue,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: IconButton(
              onPressed: () =>
                  PageRouter().navigateToPage(AddInventoryPage(), context),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))), */
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class StockOverviewData extends StatefulWidget {
  final List stockData;
  const StockOverviewData({Key? key, required this.stockData})
      : super(key: key);

  @override
  _StockOverviewDataState createState() => _StockOverviewDataState();
}

class _StockOverviewDataState extends State<StockOverviewData> {
  @override
  Widget build(BuildContext context) {
    List itemsInStock = widget.stockData;
    return ListView.builder(
        itemCount: itemsInStock.length,
        itemBuilder: (context, index) {
          String itemName = itemsInStock[index]['item_name'];
          String itemQuantity = itemsInStock[index]['quantity'];
          return Card(
            child: ExpansionTile(
              initiallyExpanded: false,
              // leading: Text(itemName),
              title: Text(
                itemName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // subtitle: Text(itemQuantity, style: TextStyle(fontWeight: FontWeight.bold),),
              /* trailing: Text(
                itemQuantity,
                style: TextStyle(fontWeight: FontWeight.bold),
              ), */
              //  onTap: () => print(itemsInStock[index]),
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Initial',
                      ),
                      Text(
                        itemQuantity,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remaining',
                      ),
                      Text(
                        mySub(itemQuantity),
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ElevatedButton(
                        onPressed: () => print('Tapped delete button!'),
                        child: Text('DELETE'),
                        style: ElevatedButton.styleFrom(primary: myRed),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ElevatedButton(
                          onPressed: () => print('Tapped take out button!'),
                          child: Text('TAKE OUT')),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ElevatedButton(
                          onPressed: () => print('Tapped details button!'),
                          child: Text('DETAILS')),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

mySub(String iniValue) {
  int valToInt = int.parse(iniValue);
  return (valToInt - 2).toString();
}
