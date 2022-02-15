import 'package:flutter/material.dart';
import 'package:ldgr/db/sp_helper.dart';
import 'package:ldgr/firebase/firestore.dart';
import 'package:ldgr/pages/stock/stock_item_details.dart';
import 'package:ldgr/services/date_time_helper.dart';
import 'package:ldgr/services/preprocessor.dart';
import 'package:ldgr/services/router.dart';
import 'package:ldgr/shared/bottom_nav_bar.dart';
import 'package:ldgr/shared/snackbar_messages.dart';
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
  TextEditingController _quantityTaken = TextEditingController();
  String? _currentUserName;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    SharedPreferencesHelper().readData('currentUserData').then((value) {
      if (value != null) {
        setState(() {
          _currentUserName = DataParser().strToMap(value)['name'];
        });
        String userRole = DataParser().strToMap(value)['role'] ?? '';
        if (userRole == 'owner' || userRole == 'admin') {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List itemsInStock = widget.stockData;
    return ListView.builder(
        itemCount: itemsInStock.length,
        itemBuilder: (context, index) {
          String _itemId = itemsInStock[index]['doc_id'];
          String _itemName = itemsInStock[index]['item_name'];
          String _itemQuantity = itemsInStock[index]['quantity'];
          List _outgoingLogs = itemsInStock[index]['removals'] ?? [];
          return Card(
            child: ExpansionTile(
              initiallyExpanded: false,
              // leading: Text(itemName),
              title: Text(
                _itemName,
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
                        _itemQuantity,
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
                        computeRemaining(_itemQuantity, _outgoingLogs),
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: _isVisible,
                        child: Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: ElevatedButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (_) =>
                                    _deleteDialog(_itemId, _itemName)),
                            child: Text('DELETE'),
                            style: ElevatedButton.styleFrom(primary: myRed),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: ElevatedButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (_) =>
                                    _takeFromStockDialog(_itemId, _itemName)),
                            child: Text('TAKE')),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: ElevatedButton(
                            onPressed: () => PageRouter().navigateToPage(
                                StockItemDetails(
                                  stockItemData: itemsInStock[index],
                                ),
                                context),
                            child: Text('DETAILS')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _takeFromStockDialog(String _currentDocId, String _currentItemName) {
    return AlertDialog(
/*       title: Icon(
        Icons.info,
        color: myBlue,
      ), */
      content: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Taking "$_currentItemName" from stock? \nEnter quantity below',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myBlue,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              margin: EdgeInsets.only(top: 20.0),
              child: TextField(
                controller: _quantityTaken,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
/*                 onChanged: (val) => setState(() {
                  print('Taking $val');
                }), */
              ),
            )
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                _quantityTaken.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCEL',
                style: TextStyle(color: myGrey, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
                onPressed: () {
                  var _fs = FirestoreService();
                  String _tsToString =
                      DateTimeHelper().timestampForDB(DateTime.now());
                  Map<String, String> _fsUpdatePayload = {
                    '_timestamp': _tsToString,
                    '_quantityTaken': _quantityTaken.text,
                    '_takenBy': _currentUserName ?? '',
                  };

                  _fs
                      .updateArrayInDocument(
                          _currentDocId, 'removals', _fsUpdatePayload)
                      .then((val) {
                    SnackBarMessage()
                        .customSuccessMessage('Logged successfully', context);
                    PageRouter().navigateToPage(StockOverviewPage(), context);
                  });
                },
                child: Text(
                  'SAVE',
                  style: TextStyle(color: myBlue, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
  }

  Widget _deleteDialog(String _stockItemId, String _stockItemName) {
    return AlertDialog(
      title: Icon(
        Icons.warning,
        color: myRed,
        size: 40.0,
      ),
      content: Text(
        'Delete ? \n"$_stockItemName"',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: myBlue, fontSize: 20.0),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'NO',
                style: TextStyle(color: myRed, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
                onPressed: () {
                  FirestoreService()
                      .removeDocFromSubCollection(
                          'records', 'stock', _stockItemId)
                      .then((val) {
                    SnackBarMessage().deleteSuccess(context);
                    PageRouter().navigateToPage(StockOverviewPage(), context);
                  }).catchError((e) =>
                          SnackBarMessage().generalErrorMessage(context));
                },
                child: Text(
                  'YES',
                  style: TextStyle(color: myGreen, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
  }
}

_subtraction(String iniValue) {
  int valToInt = int.parse(iniValue);
  return (valToInt - 2).toString();
}

computeRemaining(String _initialQty, List? _takeOutLogs) {
  if (_takeOutLogs == null) {
    return '0';
  } else if (_takeOutLogs.length < 1) {
    return '0';
  } else {
    num initialQty = num.tryParse(_initialQty) ?? 0;
    num sumRemovedQty = 0;
    for (var i in _takeOutLogs) {
      num? qTaken = num.tryParse(i['quantity_taken']) ?? 0;
      sumRemovedQty += qTaken;
    }
    num remainingQty = initialQty - sumRemovedQty;
    return remainingQty.toString();
  }
}

