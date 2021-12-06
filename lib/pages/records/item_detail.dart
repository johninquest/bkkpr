import 'package:flutter/material.dart';
import 'package:ldgr/firebase/firestore.dart';
import 'package:ldgr/pages/records/entrylist.dart';
import 'package:ldgr/services/currency.dart';
import 'package:ldgr/services/date_time_helper.dart';
import 'package:ldgr/services/router.dart';
import 'package:ldgr/shared/bottom_nav_bar.dart';
import 'package:ldgr/shared/dialogs.dart';
import 'package:ldgr/shared/snackbar_messages.dart';
import 'package:ldgr/styles/colors.dart';

class ItemDetailPage extends StatefulWidget {
  final rowData;
  const ItemDetailPage({Key? key, required this.rowData}) : super(key: key);

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  String? _currency;

  @override
  Widget build(BuildContext context) {
    CurrencyHandler().getCurrencyData().then((val) {
      if (val != null) {
        setState(() {
          _currency = val;
        });
      } else {
        setState(() {
          _currency = '';
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Item details'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyTableRow(
          rowName: 'Date',
          rowData: DateTimeHelper().toUiDateTime(widget.rowData['created_at']),
        ),
        MyTableRow(
          rowName: 'Account',
          rowData: widget.rowData['account'] ?? '',
        ),
        MyTableRow(
          rowName: 'Cost area',
          rowData: widget.rowData['cost_area'] ?? '',
        ),
        MyTableRow(
          rowName: 'Item categoy',
          rowData: widget.rowData['item_category'] ?? '',
        ),
        MyTableRow(
          rowName: 'Item name',
          rowData: widget.rowData['item_name'] ?? '',
        ),
        MyTableRow(
          rowName: 'Price',
          rowData: "$_currency ${widget.rowData['price']}",
        ),
        MyTableRow(
            rowName: 'Quantity',
            rowData: "${widget.rowData['quantity']} ${widget.rowData['unit']}"),
        MyTableRow(
          rowName: 'Payment method',
          rowData: widget.rowData['payment_method'] ?? '',
        ),
        MyTableRow(
          rowName: 'Entered by',
          rowData: widget.rowData['entered_by'] ?? '',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  String _docId = widget.rowData['doc_id'];
                  FirestoreService().removeDocument(_docId).then((val) {
                    PageRouter().navigateToPage(EntryListPage(), context);
                  }).catchError(
                      (e) => SnackBarMessage().generalErrorMessage(context));
                },
                child: Text('DELETE'),
                style: ElevatedButton.styleFrom(primary: myRed),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => InfoDialog('Coming soon')),
                child: Text('UPDATE'),
                style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
              ),
            )
          ],
        ),
      ])),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class MyTableRow extends StatelessWidget {
  final String? rowName;
  final String? rowData;
  const MyTableRow({Key? key, this.rowName, this.rowData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: myBlue, width: 1.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 1.0, left: 5.0),
            padding: EdgeInsets.only(bottom: 1.0, left: 5.0),
            child: Text(
              rowName!,
              style: TextStyle(color: myBlue, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 1.0, right: 5.0),
            padding: EdgeInsets.only(bottom: 1.0, right: 5.0),
            child: Text(rowData!.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}